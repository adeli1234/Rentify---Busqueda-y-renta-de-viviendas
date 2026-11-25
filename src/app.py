import os
import csv
import unicodedata
from apify_client import ApifyClient

# 1. Token desde variable de entorno (PowerShell: $env:APIFY_TOKEN="tu_token")
client = ApifyClient(os.getenv("TOKEN"))  # o usa os.environ["APIFY_TOKEN"] si lo guardaste en variable de entorno

# 2. Parámetros de búsqueda + proxy residencial
run_input = {
    "country": "mx",
    "operation": "rent",
    "propertyType": "apartment",
    "locations": ["queretaro/queretaro"],
    "maxListings": 50,
    "proxyConfiguration": {
        "useApifyProxy": True,
        "apifyProxyGroups": ["RESIDENTIAL"],
    },
}

# 3. Ejecutar el actor
run = client.actor("neverempty/mercadolibre-real-estate-listings").call(run_input=run_input)
dataset_id = run.default_dataset_id

# 4. Descargar items y validar que haya datos
items = list(client.dataset(dataset_id).iterate_items())
print(f"Items recibidos: {len(items)}")

if not items:
    raise SystemExit(
        "El actor no devolvió datos. MercadoLibre probablemente sigue bloqueando "
        "(revisa el log por 'verify you are a person')."
    )

print("Ejemplo de registro:", items[0])  # para ver los nombres reales de los campos

# 5. CSV crudo
csv_bytes = client.dataset(dataset_id).get_items_as_bytes(item_format="csv")
with open("propiedades_queretaro_raw.csv", "wb") as f:
    f.write(csv_bytes)

# 6. Filtro por municipio de Querétaro (cualquier colonia: Juriquilla, Centro, Milenio III...)
def normalizar(texto):
    texto = unicodedata.normalize("NFD", str(texto or ""))
    return "".join(c for c in texto if unicodedata.category(c) != "Mn").lower().strip()

def municipio(item):
    if item.get("city"):
        return normalizar(item["city"])
    ubicacion = item.get("location") or item.get("address") or ""
    return normalizar(str(ubicacion).split(",")[-1])

print("Municipios encontrados:", {municipio(i) for i in items})

filtrados = [i for i in items if municipio(i) in ("queretaro", "santiago de queretaro")]

if filtrados:
    columnas = list(filtrados[0].keys())
    with open("propiedades_ciudad_queretaro.csv", "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=columnas, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(filtrados)
    print(f"✅ Se exportaron {len(filtrados)} propiedades a 'propiedades_ciudad_queretaro.csv'")
else:
    print("⚠️ Ningún registro coincide con el filtro; revisa 'Municipios encontrados' y el ejemplo de arriba.")