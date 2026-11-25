import csv
from apify_client import ApifyClient

# 1. Inicializa el cliente con tu token de Apify
client = ApifyClient("<TU_API_TOKEN>")

# 2. Configura los parámetros delimitando a Estado/Ciudad
run_input = {
    "country": "mx",
    "operation": "sale",        # "sale" (venta) o "rent" (renta)
    "propertyType": "house",    # "house", "apartment", "land", "commercial", etc.
    "locations": ["queretaro/queretaro"],
    "maxListings": 50,
}

# 3. Ejecuta el Actor y espera a que termine
run = client.actor("neverempty/mercadolibre-real-estate-listings").call(run_input=run_input)
dataset_id = run["defaultDatasetId"]

# 4. Opción A: Descargar el CSV directamente desde Apify (tal cual viene)
csv_bytes = client.dataset(dataset_id).download_items(item_format="csv")
with open("propiedades_queretaro_raw.csv", "wb") as f:
    f.write(csv_bytes)

# 5. Opción B (Recomendada): Filtrar exactamente por ciudad y guardar CSV limpio
items = list(client.dataset(dataset_id).iterate_items())

# Filtramos asegurando que el estado y la ciudad correspondan a Querétaro
filtrados = [
    item for item in items
    if "querétaro" in str(item.get("state", "")).lower() or "queretaro" in str(item.get("state", "")).lower()
    if "querétaro" in str(item.get("city", "")).lower() or "queretaro" in str(item.get("city", "")).lower()
]

if filtrados:
    # Obtener todas las columnas posibles de los registros
    columnas = list(filtrados[0].keys())
    with open("propiedades_ciudad_queretaro.csv", "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(f, fieldnames=columnas, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(filtrados)
    print(f"✅ Se exportaron {len(filtrados)} propiedades a 'propiedades_ciudad_queretaro.csv'")
else:
    print("⚠️ No se encontraron registros que coincidan con el filtro exacto de ciudad.")