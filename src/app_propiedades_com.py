import csv
import re
from playwright.sync_api import sync_playwright

URL_BASE = "https://propiedades.com/queretaro-queretaro"  # pega aquí la URL ya filtrada a renta/departamentos
MAX_PAGINAS = 5

def parsear(texto):
    def buscar(patron):
        m = re.search(patron, texto, re.I)
        return m.group(1).strip() if m else ""
    return {
        "tipo_operacion": " ".join(re.findall(r"\b(DEPARTAMENTO|CASA|VENTA|RENTA)\b", texto)[:2]),
        "precio": buscar(r"\$\s?([\d,]+)"),
        "recamaras": buscar(r"(\d+)\s*Rec[aá]maras?"),
        "banos": buscar(r"(\d+)\s*Ba[ñn]os?"),
        "m2": buscar(r"(\d+)\s*m\s*[²2]"),
        "direccion": buscar(r"((?:Boulevard|Av|Calle|Col\.|Venta|Renta)[^\n]*M[eé]xico[^\n]*)"),
        "id": buscar(r"ID:\s*(\d+)"),
    }

resultados = []
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()

    for n in range(1, MAX_PAGINAS + 1):
        url = URL_BASE if n == 1 else f"{URL_BASE}?pagina={n}"  # AJUSTA según lo que veas al cambiar de página
        page.goto(url, wait_until="domcontentloaded")
        page.wait_for_timeout(3000)

        # scroll para cargar las tarjetas perezosas
        for _ in range(6):
            page.mouse.wheel(0, 2500)
            page.wait_for_timeout(600)

        # Cada tarjeta contiene el botón "Contactar": subimos al contenedor más cercano
        tarjetas = page.locator("div:has(> div button:has-text('Contactar'))")
        total = tarjetas.count()
        if total == 0:
            tarjetas = page.locator("div:has(button:has-text('Contactar'))").filter(has_text="m²")
            total = tarjetas.count()
        print(f"Página {n}: {total} tarjetas")
        if total == 0:
            break

        for i in range(total):
            texto = tarjetas.nth(i).inner_text()
            fila = parsear(texto)
            if fila["id"]:
                resultados.append(fila)

    browser.close()

# Quitar duplicados por ID (el selector anidado puede repetir tarjetas)
unicos = {r["id"]: r for r in resultados}.values()

# Filtro por municipio: la dirección termina en "..., Municipio, Estado, México"
solo_queretaro = [r for r in unicos if "querétaro, querétaro, méxico" in r["direccion"].lower()]

with open("propiedades_com_queretaro.csv", "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=list(solo_queretaro[0].keys()) if solo_queretaro else ["id"])
    w.writeheader()
    w.writerows(solo_queretaro)

print(f"✅ {len(solo_queretaro)} propiedades del municipio de Querétaro")