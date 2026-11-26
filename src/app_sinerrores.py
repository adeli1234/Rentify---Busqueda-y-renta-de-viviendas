import csv
import math
import os
import random
import re
import time
import requests
from playwright.sync_api import sync_playwright
from playwright.sync_api import TimeoutError as PWTimeout

BASE = "https://inmuebles.mercadolibre.com.mx/departamentos/renta/queretaro/queretaro/"
MAX_PAGINAS = 5
MAX_DETALLES = 240                 # anuncios por corrida; corre en tandas con descansos
PAUSA_MIN, PAUSA_MAX = 10, 16     # pausa aleatoria entre anuncios (segundos)
MAX_FALLOS_SEGUIDOS = 3
RADIO_M = 1500
MAX_POR_CATEGORIA = 2
GUARDAR_CARACTERISTICAS = True   # True = también guarda las demás tablas
ARCHIVO = "propiedades_queretaro_completo.csv"
COLUMNAS = ["titulo", "precio", "atributos", "ubicacion", "url", "foto_portada", "fotos",
            "vendedor", "servicios", "caracteristicas", "coordenadas",
            "escuelas", "areas_verdes", "salud", "comercios", "procesado"]

OVERPASS_URL = "https://overpass-api.de/api/interpreter"
HEADERS_API = {"User-Agent": "Rentify-proyecto-personal/1.0"}

JS_FOTOS = """
() => {
  const sel = '[class*="gallery"] img, [role="dialog"] img, [class*="vip-gallery"] img';
  return [...document.querySelectorAll(sel)].map(e =>
    e.getAttribute('data-zoom') || e.getAttribute('data-src') ||
    (e.getAttribute('srcset') || '').split(' ')[0] || e.src
  );
}
"""

JS_AGENTE = """
() => {
  const rx = /^Informaci[oó]n del (agente inmobiliario|vendedor|anunciante|propietario)/i;
  const h = [...document.querySelectorAll('h1,h2,h3,h4,h5,div,span,p')]
    .find(e => e.children.length === 0 && rx.test((e.innerText || '').trim()));
  if (!h) return null;
  let box = h;
  for (let i = 0; i < 6 && box.parentElement; i++) {
    box = box.parentElement;
    if (/C[oó]digo de la propiedad|Ver propiedades|Ver tel[eé]fono/i.test(box.innerText)) break;
  }
  return {texto: box.innerText};
}
"""

JS_TABLAS = """
() => {
  const out = [];
  document.querySelectorAll('table').forEach(t => {
    let titulo = '';
    let el = t;
    for (let i = 0; i < 5 && el && !titulo; i++) {
      const prev = el.previousElementSibling;
      if (prev) {
        const txt = (prev.innerText || '').trim();
        if (txt && txt.length < 80) titulo = txt.split('\\n')[0].trim();
      }
      el = el.parentElement;
    }
    const filas = [];
    t.querySelectorAll('tr').forEach(tr => {
      const celdas = [...tr.children].map(c => (c.innerText || '').trim().replace(/\\s+/g, ' '));
      if (celdas.length >= 2 && celdas[0]) filas.push([celdas[0], celdas[1]]);
    });
    if (filas.length) out.push({titulo, filas});
  });
  return out;
}
"""

LINEAS_IGNORADAS = re.compile(
    r"^(Respuestas a consultas|Basado en opiniones|Ver propiedades|Ver tel[eé]fono|"
    r"C[oó]digo de la propiedad|Informaci[oó]n del)", re.I)

PATRONES_COORD = [
    r"center=(-?\d{1,2}\.\d+)(?:%2C|,)(-?\d{2,3}\.\d+)",
    r"markers=[^&]*?(-?\d{1,2}\.\d+)(?:%2C|,)(-?\d{2,3}\.\d+)",
    r'"latitude"\s*:\s*(-?\d{1,2}\.\d+)\s*,\s*"longitude"\s*:\s*(-?\d{2,3}\.\d+)',
    r'"lat"\s*:\s*(-?\d{1,2}\.\d+)\s*,\s*"(?:lng|lon|long)"\s*:\s*(-?\d{2,3}\.\d+)',
]


# ---------- Utilidades de navegación ----------

def hay_verificacion(page):
    return "account-verification" in page.url


def esperar_verificacion(page):
    if hay_verificacion(page):
        input("MercadoLibre pide verificación. Resuélvela en el navegador y presiona Enter aquí...")
        page.wait_for_timeout(2000)


def ir_a(page, url, intentos=2):
    """goto con timeout largo y reintento. Devuelve True si cargó."""
    for k in range(intentos):
        try:
            page.goto(url, wait_until="domcontentloaded", timeout=60000)
            return True
        except PWTimeout:
            print(f"   ⏱️ Timeout cargando la página (intento {k + 1}/{intentos})")
            time.sleep(15)
        except Exception as e:
            print(f"   ⚠️ Error de navegación: {type(e).__name__}")
            time.sleep(10)
    return False


# ---------- Listado ----------

def extraer(page):
    filas = []
    for card in page.query_selector_all("li.ui-search-layout__item"):
        def txt(sel):
            el = card.query_selector(sel)
            return el.inner_text().strip() if el else ""

        link = card.query_selector("a")
        img = card.query_selector("img")
        foto = ""
        if img:
            foto = img.get_attribute("data-src") or img.get_attribute("src") or ""
            if foto.startswith("data:"):
                foto = ""

        filas.append({
            "titulo": txt("a.poly-component__title"),
            "precio": txt(".andes-money-amount__fraction"),
            "atributos": txt(".poly-component__attributes-list"),
            "ubicacion": txt(".poly-component__location"),
            "url": link.get_attribute("href") if link else "",
            "foto_portada": foto,
            "fotos": "", "vendedor": "", "coordenadas": "",
            "servicios": "n/a", "caracteristicas": "n/a",
            "escuelas": "n/a", "areas_verdes": "n/a", "salud": "n/a", "comercios": "n/a",
            "procesado": "",
        })
    return filas


# ---------- Lectura del detalle ----------

def leer_fotos(page):
    urls = page.evaluate(JS_FOTOS)
    vistos, claves = [], set()
    for u in urls:
        if not u or u.startswith("data:") or "mlstatic" not in u:
            continue
        m = re.search(r"(\d{6,}-MLM\d+_\d+)", u)
        clave = m.group(1) if m else u
        if clave not in claves:
            claves.add(clave)
            vistos.append(u)
    return " | ".join(vistos)


def leer_vendedor(page):
    try:
        bloque = page.evaluate(JS_AGENTE)
    except Exception:
        bloque = None
    if not bloque:
        return ""
    for l in (x.strip() for x in bloque["texto"].split("\n") if x.strip()):
        if not LINEAS_IGNORADAS.match(l):
            return l
    return ""


def leer_caracteristicas(page):
    """Devuelve (servicios, otras_caracteristicas). 'n/a' si no hay."""
    try:
        page.get_by_text(re.compile(r"Ver todas las caracter[ií]sticas", re.I)).first.click(timeout=2000)
        page.wait_for_timeout(1000)
    except Exception:
        pass

    try:
        tablas = page.evaluate(JS_TABLAS)
    except Exception:
        tablas = []

    servicios, otras = [], []
    for t in tablas:
        filas = [f"{e}: {v}" if v else e for e, v in t["filas"]]
        if re.search(r"servicios", t["titulo"], re.I):
            servicios += filas
        else:
            otras.append(f"[{t['titulo'] or 'Otras'}] " + " | ".join(filas))

    return (" | ".join(servicios) or "n/a"), (" || ".join(otras) or "n/a")


def leer_coordenadas(page):
    try:
        html = page.content()
    except Exception:
        return None
    for patron in PATRONES_COORD:
        for m in re.finditer(patron, html):
            lat, lon = float(m.group(1)), float(m.group(2))
            if 19.5 <= lat <= 22 and -101.5 <= lon <= -99:
                return lat, lon
    return None


# ---------- Lugares cercanos (OpenStreetMap) ----------

def distancia_m(lat1, lon1, lat2, lon2):
    R = 6371000
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp, dl = p2 - p1, math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * R * math.asin(math.sqrt(a))


def tiempos(dist_m):
    """Estimación: a pie ~4.8 km/h con rodeo x1.3; en auto ~24 km/h urbano con rodeo x1.4."""
    a_pie = max(1, round(dist_m * 1.3 / 80))
    en_auto = max(1, round(dist_m * 1.4 / 400))
    return a_pie, en_auto


def categoria(tags):
    am, le, sh, hc = tags.get("amenity"), tags.get("leisure"), tags.get("shop"), tags.get("healthcare")
    if am in ("school", "kindergarten", "college", "university"):
        return "escuelas"
    if le in ("park", "garden", "playground", "nature_reserve") or tags.get("landuse") == "recreation_ground":
        return "areas_verdes"
    if am in ("hospital", "clinic", "doctors", "pharmacy") or hc:
        return "salud"
    if sh in ("supermarket", "convenience", "mall", "department_store", "bakery") or am == "marketplace":
        return "comercios"
    return None


NOMBRE_GENERICO = {
    "school": "Escuela", "kindergarten": "Kínder", "college": "Colegio", "university": "Universidad",
    "park": "Parque", "garden": "Jardín", "playground": "Área de juegos", "nature_reserve": "Reserva",
    "hospital": "Hospital", "clinic": "Clínica", "doctors": "Consultorio", "pharmacy": "Farmacia",
    "supermarket": "Supermercado", "convenience": "Tienda", "mall": "Centro comercial",
    "department_store": "Tienda departamental", "bakery": "Panadería", "marketplace": "Mercado",
}


def lugares_cercanos(lat, lon):
    vacio = {k: "n/a" for k in ("escuelas", "areas_verdes", "salud", "comercios")}
    q = f"""
    [out:json][timeout:40];
    (
      nwr(around:{RADIO_M},{lat},{lon})["amenity"~"^(school|kindergarten|college|university|hospital|clinic|doctors|pharmacy|marketplace)$"];
      nwr(around:{RADIO_M},{lat},{lon})["leisure"~"^(park|garden|playground|nature_reserve)$"];
      nwr(around:{RADIO_M},{lat},{lon})["shop"~"^(supermarket|convenience|mall|department_store|bakery)$"];
      nwr(around:{RADIO_M},{lat},{lon})["healthcare"];
    );
    out center tags;
    """
    datos = None
    for intento in range(3):
        try:
            resp = requests.post(OVERPASS_URL, data={"data": q}, headers=HEADERS_API, timeout=60)
            if resp.ok:
                datos = resp.json()
                break
        except Exception:
            pass
        time.sleep(5 * (intento + 1))
    if datos is None:
        print("   ⚠️ Overpass no respondió; se deja n/a")
        return vacio

    por_cat = {k: {} for k in vacio}
    for el in datos.get("elements", []):
        tags = el.get("tags", {})
        cat = categoria(tags)
        if not cat:
            continue
        la = el.get("lat") or el.get("center", {}).get("lat")
        lo = el.get("lon") or el.get("center", {}).get("lon")
        if la is None or lo is None:
            continue
        clave_tipo = tags.get("amenity") or tags.get("leisure") or tags.get("shop") or tags.get("healthcare", "")
        nombre = tags.get("name") or f"{NOMBRE_GENERICO.get(clave_tipo, 'Lugar')} (sin nombre)"
        d = distancia_m(lat, lon, la, lo)
        if nombre not in por_cat[cat] or d < por_cat[cat][nombre]:
            por_cat[cat][nombre] = d

    salida = dict(vacio)
    for cat, lugares in por_cat.items():
        cercanos = sorted(lugares.items(), key=lambda x: x[1])[:MAX_POR_CATEGORIA]
        if cercanos:
            partes = []
            for nombre, d in cercanos:
                pie, auto = tiempos(d)
                partes.append(f"{nombre} ({round(d)} m, ~{pie} min a pie / ~{auto} min en auto)")
            salida[cat] = " | ".join(partes)
    return salida


# ---------- Detalle de un anuncio ----------

def detalle(page, r, idx):
    """Devuelve True si se procesó bien, False si no se pudo cargar."""
    if not ir_a(page, r["url"]):
        return False
    esperar_verificacion(page)

    try:
        page.get_by_role("button", name=re.compile(r"Aceptar cookies", re.I)).click(timeout=1500)
    except Exception:
        pass

    if page.get_by_text(re.compile(r"verify you are|no soy un robot|verifica", re.I)).count():
        input("Posible verificación en pantalla. Resuélvela y presiona Enter...")

    page.wait_for_timeout(2500)

    # Scroll para que carguen vendedor, características y mapa
    for _ in range(6):
        page.mouse.wheel(0, 1200)
        page.wait_for_timeout(400)
    r["vendedor"] = leer_vendedor(page)

    servicios, otras = leer_caracteristicas(page)
    r["servicios"] = servicios
    r["caracteristicas"] = otras if GUARDAR_CARACTERISTICAS else "n/a"
    if servicios == "n/a":
        print("   ⚠️ No se encontró la sección de servicios en este anuncio")

    coords = leer_coordenadas(page)
    if coords:
        r["coordenadas"] = f"{coords[0]}, {coords[1]}"
        r.update(lugares_cercanos(*coords))
        time.sleep(2)
    else:
        r["coordenadas"] = "n/a"
        print("   ⚠️ No se encontraron coordenadas; lugares cercanos = n/a")

    page.evaluate("window.scrollTo(0, 0)")
    page.wait_for_timeout(500)

    # Fotos
    try:
        page.get_by_text(re.compile(r"\d+\s*Fotos?", re.I)).first.click(timeout=2000)
        page.wait_for_timeout(1500)
        for _ in range(5):
            page.keyboard.press("ArrowRight")
            page.wait_for_timeout(300)
    except Exception:
        pass
    r["fotos"] = leer_fotos(page)
    try:
        page.keyboard.press("Escape")
    except Exception:
        pass

    if not r["fotos"]:
        print(f"   ⚠️ 0 fotos. Título: {page.title()!r} | URL: {page.url}")
        page.screenshot(path=f"debug_{idx}.png")
    if not r["vendedor"]:
        print("   ⚠️ No se detectó el bloque del vendedor en este anuncio")

    r["procesado"] = "si"
    return True


# ---------- Utilidades de datos ----------

def es_municipio_queretaro(r):
    return r["ubicacion"].lower().rstrip().endswith("querétaro")


def guardar(resultados):
    with open(ARCHIVO, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNAS, extrasaction="ignore", restval="n/a")
        w.writeheader()
        w.writerows(resultados)


def base_url(url):
    """Quita el '#polycard...' para comparar anuncios aunque cambie el tracking."""
    return url.split("#")[0]


def cargar_previos():
    """Lee el CSV anterior para no repetir anuncios ya procesados."""
    if not os.path.exists(ARCHIVO):
        return {}
    try:
        with open(ARCHIVO, encoding="utf-8-sig", newline="") as f:
            return {base_url(row["url"]): row for row in csv.DictReader(f)
                    if row.get("procesado") == "si"}
    except Exception:
        return {}


# ---------- Programa principal ----------

resultados = []
try:
    previos = cargar_previos()
    if previos:
        print(f"Se encontraron {len(previos)} anuncios ya procesados en {ARCHIVO}; se omitirán.")

    with sync_playwright() as p:
        context = p.chromium.launch_persistent_context("perfil_ml", headless=False)
        page = context.pages[0] if context.pages else context.new_page()

        # --- Fase 1: listado ---
        for n in range(MAX_PAGINAS):
            url = BASE if n == 0 else f"{BASE}_Desde_{n * 48 + 1}_NoIndex_True"
            if not ir_a(page, url):
                print(f"No se pudo cargar la página {n + 1} del listado; paso a la fase 2.")
                break
            esperar_verificacion(page)
            page.wait_for_timeout(2000)
            for _ in range(6):
                page.mouse.wheel(0, 2500)
                page.wait_for_timeout(500)
            filas = extraer(page)
            print(f"Página {n + 1}: {len(filas)} anuncios")
            if not filas:
                break
            resultados.extend(filas)
            time.sleep(2)

        resultados = [r for r in resultados if es_municipio_queretaro(r)]

        # Reutilizar lo ya procesado en corridas anteriores
        for i, r in enumerate(resultados):
            previo = previos.get(base_url(r["url"]))
            if previo:
                resultados[i] = {**r, **previo}
        print(f"{len(resultados)} anuncios del municipio de Querétaro "
              f"({sum(1 for r in resultados if r.get('procesado') == 'si')} ya procesados)")

        # --- Fase 2: detalle con tolerancia a fallos ---
        pendientes = [r for r in resultados if r.get("procesado") != "si" and r["url"]]
        pendientes = pendientes[:MAX_DETALLES]
        fallos_seguidos = 0

        for i, r in enumerate(pendientes, 1):
            try:
                ok = detalle(page, r, i)
            except Exception as e:
                print(f"   ❌ Error en el anuncio {i}: {type(e).__name__}")
                ok = False

            if ok:
                fallos_seguidos = 0
                n_fotos = len(r["fotos"].split(" | ")) if r["fotos"] else 0
                print(f"[{i}/{len(pendientes)}] {n_fotos} fotos | vendedor: {r['vendedor'] or '—'} "
                      f"| servicios: {'sí' if r['servicios'] != 'n/a' else 'n/a'}")
                guardar(resultados)
                time.sleep(random.uniform(PAUSA_MIN, PAUSA_MAX))
            else:
                fallos_seguidos += 1
                print(f"[{i}/{len(pendientes)}] ❌ no se pudo procesar ({fallos_seguidos}/{MAX_FALLOS_SEGUIDOS})")
                if fallos_seguidos >= MAX_FALLOS_SEGUIDOS:
                    print("Varios fallos seguidos: probablemente MercadoLibre está limitando el ritmo. "
                          "Me detengo; espera 20-30 minutos y vuelve a correr (retomará donde quedó).")
                    break
                time.sleep(30)

        context.close()
finally:
    guardar(resultados)
    print(f"✅ {len(resultados)} propiedades guardadas en {ARCHIVO}")