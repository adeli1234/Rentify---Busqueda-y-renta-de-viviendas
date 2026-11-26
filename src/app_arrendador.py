import csv
import re
import time
from playwright.sync_api import sync_playwright

BASE = "https://inmuebles.mercadolibre.com.mx/departamentos/renta/queretaro/queretaro/"
MAX_PAGINAS = 3
MAX_DETALLES = 5          # anuncios a visitar (fotos + vendedor)
PAUSA_DETALLE = 8
CAPTURAR_CONTACTO = True   # True = se pausa en cada anuncio para que tú reveles el contacto
ARCHIVO = "propiedades_queretaro_arrendador_prueba.csv"
COLUMNAS = ["titulo", "precio", "atributos", "ubicacion", "url", "foto_portada", "fotos",
            "vendedor", "tipo_vendedor", "perfil_vendedor", "telefono", "whatsapp"]

JS_FOTOS = """
() => {
  const sel = '[class*="gallery"] img, [role="dialog"] img, [class*="vip-gallery"] img';
  return [...document.querySelectorAll(sel)].map(e =>
    e.getAttribute('data-zoom') || e.getAttribute('data-src') ||
    (e.getAttribute('srcset') || '').split(' ')[0] || e.src
  );
}
"""

# Selectores candidatos del bloque del vendedor (MercadoLibre los cambia seguido)
SEL_VENDEDOR = [
    ".ui-pdp-seller__header__title",
    ".ui-vip-profile-info__info-container a",
    ".ui-pdp-seller__link-trigger",
    "[class*='seller'] [class*='title']",
    "[class*='profile-info'] a",
]


def hay_verificacion(page):
    return "account-verification" in page.url


def esperar_verificacion(page):
    if hay_verificacion(page):
        input("MercadoLibre pide verificación. Resuélvela en el navegador y presiona Enter aquí...")
        page.wait_for_timeout(2000)


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
            "fotos": "", "vendedor": "", "tipo_vendedor": "",
            "perfil_vendedor": "", "telefono": "", "whatsapp": "",
        })
    return filas


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
    """Nombre, tipo (inmobiliaria / particular) y perfil del anunciante."""
    nombre, perfil = "", ""
    for sel in SEL_VENDEDOR:
        try:
            el = page.query_selector(sel)
            if el and el.inner_text().strip():
                nombre = el.inner_text().strip().split("\n")[0]
                perfil = el.get_attribute("href") or ""
                break
        except Exception:
            continue

    cuerpo = ""
    try:
        cuerpo = page.inner_text("body")
    except Exception:
        pass

    if not nombre:  # respaldo: texto cercano a "Publicado por" / "Vendedor"
        m = re.search(r"(?:Publicado por|Vendedor|Inmobiliaria)\s*[:\n]\s*([^\n]{2,80})", cuerpo, re.I)
        nombre = m.group(1).strip() if m else ""

    tipo = ""
    if re.search(r"inmobiliaria|bienes ra[ií]ces|real estate|re/?max|century", nombre + " " + cuerpo[:3000], re.I):
        tipo = "inmobiliaria/agente"
    elif re.search(r"\bparticular\b|due[ñn]o directo", cuerpo, re.I):
        tipo = "particular"
    return nombre, tipo, perfil


def leer_contacto(page):
    """Lee lo que quedó visible DESPUÉS de que tú reveles el contacto."""
    tel, wa = [], []
    hrefs = page.eval_on_selector_all(
        "a[href^='tel:'], a[href*='wa.me'], a[href*='whatsapp.com']",
        "els => els.map(e => e.href)",
    )
    for h in hrefs:
        if h.startswith("tel:"):
            tel.append(h[4:])
        else:
            wa.append(h)
    try:
        cuerpo = page.inner_text("body")
        tel += re.findall(r"(?<!\d)(?:\+?52\s?)?(?:\(?\d{2,3}\)?[\s\-]?)\d{3,4}[\s\-]?\d{4}(?!\d)", cuerpo)
    except Exception:
        pass
    unicos = lambda xs: " | ".join(dict.fromkeys(x.strip() for x in xs if x.strip()))
    return unicos(tel), unicos(wa)


def detalle(page, r, idx):
    page.goto(r["url"], wait_until="domcontentloaded")
    esperar_verificacion(page)

    try:
        page.get_by_role("button", name=re.compile(r"Aceptar cookies", re.I)).click(timeout=1500)
    except Exception:
        pass

    if page.get_by_text(re.compile(r"verify you are|no soy un robot|verifica", re.I)).count():
        input("Posible verificación en pantalla. Resuélvela y presiona Enter...")

    page.wait_for_timeout(2500)

    # Vendedor (visible sin verificación)
    r["vendedor"], r["tipo_vendedor"], r["perfil_vendedor"] = leer_vendedor(page)

    # Fotos: abrir galería completa
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

    # Contacto: lo revelas tú
    if CAPTURAR_CONTACTO:
        input(f"[{idx}] {r['vendedor'] or 'vendedor no detectado'} — si quieres su contacto, haz clic en "
              f"'Ver teléfono'/'WhatsApp', resuelve la verificación y presiona Enter "
              f"(Enter sin hacer nada = omitir)...")
        r["telefono"], r["whatsapp"] = leer_contacto(page)


def es_municipio_queretaro(r):
    return r["ubicacion"].lower().rstrip().endswith("querétaro")


def guardar(resultados):
    with open(ARCHIVO, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=COLUMNAS, extrasaction="ignore")
        w.writeheader()
        w.writerows(resultados)


resultados = []
try:
    with sync_playwright() as p:
        context = p.chromium.launch_persistent_context("perfil_ml", headless=False)
        page = context.pages[0] if context.pages else context.new_page()

        # --- Fase 1: listado ---
        for n in range(MAX_PAGINAS):
            url = BASE if n == 0 else f"{BASE}_Desde_{n * 48 + 1}_NoIndex_True"
            page.goto(url, wait_until="domcontentloaded")
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
        print(f"{len(resultados)} anuncios del municipio de Querétaro")

        # --- Fase 2: detalle (fotos + vendedor + contacto opcional) ---
        total = min(MAX_DETALLES, len(resultados))
        for i, r in enumerate(resultados[:MAX_DETALLES], 1):
            if not r["url"]:
                continue
            detalle(page, r, i)
            n_fotos = len(r["fotos"].split(" | ")) if r["fotos"] else 0
            print(f"[{i}/{total}] {n_fotos} fotos | vendedor: {r['vendedor'] or '—'} | tel: {r['telefono'] or '—'}")
            guardar(resultados)  # guarda en cada vuelta
            time.sleep(PAUSA_DETALLE)

        context.close()
finally:
    guardar(resultados)
    print(f"✅ {len(resultados)} propiedades guardadas en {ARCHIVO}")