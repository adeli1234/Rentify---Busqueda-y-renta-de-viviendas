import csv
import time
from playwright.sync_api import sync_playwright

BASE = "https://inmuebles.mercadolibre.com.mx/departamentos/venta/queretaro/queretaro/"
MAX_PAGINAS = 10        # ~48 resultados por página
MAX_DETALLES = 20       # cuántos anuncios visitar para sacar TODAS las fotos (0 = solo portada)
PAUSA_DETALLE = 5       # segundos entre visitas a anuncios
ARCHIVO = "propiedades_queretaro.csv"
COLUMNAS = ["titulo", "precio", "atributos", "ubicacion", "url", "foto_portada", "fotos"]


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
            if foto.startswith("data:"):  # placeholder de carga perezosa
                foto = ""

        filas.append({
            "titulo": txt("a.poly-component__title"),
            "precio": txt(".andes-money-amount__fraction"),
            "atributos": txt(".poly-component__attributes-list"),
            "ubicacion": txt(".poly-component__location"),
            "url": link.get_attribute("href") if link else "",
            "foto_portada": foto,
            "fotos": "",
        })
    return filas


def fotos_detalle(page, url):
    page.goto(url, wait_until="domcontentloaded")
    esperar_verificacion(page)
    page.wait_for_timeout(2000)
    urls = page.eval_on_selector_all(
        "figure.ui-pdp-gallery__figure img, .ui-pdp-gallery img",
        "els => els.map(e => e.getAttribute('data-zoom') || e.getAttribute('data-src') || e.src)",
    )
    vistos = []
    for u in urls:
        if u and not u.startswith("data:") and u not in vistos:
            vistos.append(u)
    return " | ".join(vistos)


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
        # Perfil persistente: conserva cookies entre ejecuciones (carpeta "perfil_ml")
        context = p.chromium.launch_persistent_context("perfil_ml", headless=False)
        page = context.pages[0] if context.pages else context.new_page()

        # --- Fase 1: listado (con portada) ---
        for n in range(MAX_PAGINAS):
            url = BASE if n == 0 else f"{BASE}_Desde_{n * 48 + 1}_NoIndex_True"
            page.goto(url, wait_until="domcontentloaded")
            esperar_verificacion(page)
            page.wait_for_timeout(2000)

            # scroll para que se carguen las imágenes perezosas
            for _ in range(6):
                page.mouse.wheel(0, 2500)
                page.wait_for_timeout(500)

            filas = extraer(page)
            print(f"Página {n + 1}: {len(filas)} anuncios")
            if not filas:
                break
            resultados.extend(filas)
            time.sleep(2)

        # Filtro por municipio: la ubicación viene como "Colonia, Municipio"
        resultados = [r for r in resultados if es_municipio_queretaro(r)]
        print(f"{len(resultados)} anuncios del municipio de Querétaro")

        # --- Fase 2: todas las fotos de cada anuncio (opcional) ---
        for i, r in enumerate(resultados[:MAX_DETALLES], 1):
            if not r["url"]:
                continue
            r["fotos"] = fotos_detalle(page, r["url"])
            n_fotos = len(r["fotos"].split(" | ")) if r["fotos"] else 0
            print(f"[{i}/{min(MAX_DETALLES, len(resultados))}] {n_fotos} fotos")
            time.sleep(PAUSA_DETALLE)

        context.close()
finally:
    # Se guarda aunque canceles con Ctrl+C o falle algo a la mitad
    guardar(resultados)
    print(f"✅ {len(resultados)} propiedades guardadas en {ARCHIVO}")