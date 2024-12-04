#!/bin/bash

# Verifica si se proporcionaron argumentos
if [ "$#" -eq 0 ]; then
    echo "No se proporcionaron nombres de proveedores."
    exit 1
fi

DESTINATION_POSITION_FILE="./api/core/model_runtime/model_providers/_position.yaml"

# Verifica si el archivo existe
if [ ! -f "$DESTINATION_POSITION_FILE" ]; then
    echo "El archivo destino $DESTINATION_POSITION_FILE no existe."
    exit 1
fi

# Itera sobre cada argumento (nombre de proveedor)
for PROVIDER_NAME in "$@"; do
    # Verifica si el proveedor ya existe
    if ! grep -q "^\\- $PROVIDER_NAME\$" "$DESTINATION_POSITION_FILE"; then
        # Añade el proveedor al final del archivo YAML
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' -e "\$a\\
- $PROVIDER_NAME" "$DESTINATION_POSITION_FILE" || {
                echo "Error al agregar $PROVIDER_NAME en macOS."
                exit 1
            }
        else
            sed -i "\$a\- $PROVIDER_NAME" "$DESTINATION_POSITION_FILE" || {
                echo "Error al agregar $PROVIDER_NAME en Linux."
                exit 1
            }
        fi
        echo "Proveedor $PROVIDER_NAME agregado."
    else
        echo "Proveedor $PROVIDER_NAME ya existe en el archivo."
    fi
done

# Mensaje final
echo "Todos los proveedores han sido procesados correctamente."

exit 0
