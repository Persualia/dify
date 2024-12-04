#!/bin/bash
# Lista de nombres de clientes
CLIENT_NAMES=(
    "sibilare"    
    # Añade más clientes según necesites
)

PROVIDERS=()
for CLIENT_NAME in "${CLIENT_NAMES[@]}"; do
    PROVIDER=$(./bash_add_anthropic_provider.sh "$CLIENT_NAME")
    PROVIDERS+=("$PROVIDER")
    PROVIDER=$(./bash_add_openai_provider.sh "$CLIENT_NAME")
    PROVIDERS+=("$PROVIDER")
    PROVIDER=$(./bash_add_google_provider.sh "$CLIENT_NAME")
    PROVIDERS+=("$PROVIDER")
    
    # Agregar lógica adicional para el cliente si es necesario
    echo "Cliente '$CLIENT_NAME' agregado correctamente."
done

echo "PROVIDERS: ${PROVIDERS[@]}"

# Reordenar alfabéticamente el array PROVIDERS
PROVIDERS=($(for p in "${PROVIDERS[@]}"; do echo "$p"; done | sort))

# Pasar la lista separada por comas al segundo script
./bash_add_providers.sh "${PROVIDERS[@]}"


# Agregar lógica adicional para el cliente si es necesario
echo "Script ejecutado correctamente."

exit 0
