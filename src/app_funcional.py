import csv
import re
import time
from playwright.sync_api import sync_playwright

BASE = "https://inmuebles.mercadolibre.com.mx/departamentos/renta/queretaro/queretaro/"
MAX_PAGINAS = 10  # ~48 resultados por página

def extraer(page):
    filas = []
    for card in page.query_selector_all("li.ui-search-layout__item"):
        def txt(sel):
            el = card.query_selector(sel)
            return el.inner_text().strip() if el else ""
        link = card.query_selector("a")
        filas.append({
            "titulo": txt("a.poly-component__title"),
            "precio": txt(".andes-money-amount__fraction"),
            "atributos": txt(".poly-component__attributes-list"),
            "ubicacion": txt(".poly-component__location"),
            "url": link.get_attribute("href") if link else "",
        })
    return filas

resultados = []
with sync_playwright() as p:
    # headless=False para que veas el navegador y puedas resolver la verificación si aparece
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()

    for n in range(MAX_PAGINAS):
        url = BASE if n == 0 else f"{BASE}_Desde_{n * 48 + 1}_NoIndex_True"
        page.goto(url, wait_until="domcontentloaded")

        if "account-verification" in page.url:
            input("MercadoLibre pide verificación. Resuélvela en el navegador y presiona Enter aquí...")

        page.wait_for_timeout(2000)
        filas = extraer(page)
        print(f"Página {n + 1}: {len(filas)} anuncios")
        if not filas:
            break
        resultados.extend(filas)
        time.sleep(2)  # pausa para no saturar

    browser.close()

# Filtro por municipio: la ubicación viene como "Colonia, Municipio"
resultados = [r for r in resultados if r["ubicacion"].lower().rstrip().endswith("querétaro")]

with open("propiedades_queretaro.csv", "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=["titulo", "precio", "atributos", "ubicacion", "url"])
    w.writeheader()
    w.writerows(resultados)

print(f"✅ {len(resultados)} propiedades guardadas en propiedades_queretaro.csv")