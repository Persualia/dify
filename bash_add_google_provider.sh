#!/bin/bash

# Verificar si se ha proporcionado el parámetro
if [ -z "$1" ]; then
  echo "Error: Debes proporcionar un nombre de cliente como parámetro."
  echo "Uso: ./add_client.sh <client_name>"
  exit 1
fi

# Asignar el parámetro a una variable
CLIENT_NAME=$1


# Ruta al directorio del provider que quieres copiar
SOURCE_FOLDER="./api/core/model_runtime/model_providers/google"
# Convertir el nombre del cliente a minúsculas y reemplazar espacios con guiones bajos
CLIENT_NAME_FORMATTED=$(echo "$CLIENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Ruta al directorio donde quieres hacer la copia
DESTINATION_FOLDER="./api/core/model_runtime/model_providers/${CLIENT_NAME_FORMATTED}_google"

# Crear el directorio de destino si no existe
mkdir -p "$DESTINATION_FOLDER"

# Copiar los archivos
cp -R "$SOURCE_FOLDER/" "$DESTINATION_FOLDER"

# Renombrar el archivo google.py
mv "$DESTINATION_FOLDER/google.py" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.py"
mv "$DESTINATION_FOLDER/google.yaml" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"


# Modificar el contenido del archivo YAML
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version
    sed -i '' "s/^provider: google/provider: ${CLIENT_NAME_FORMATTED}_google/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    sed -i '' "s/en_US: Google/en_US: ${CLIENT_NAME_FORMATTED} Google/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    #sed -i '' "s/Google's Gemini model./${CLIENT_NAME_FORMATTED} Google's Gemini model./" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    sed -i '' "s/google_api_key/${CLIENT_NAME_FORMATTED}_google_api_key/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"    
    sed -i '' "s/google_api_key/${CLIENT_NAME_FORMATTED}_google_api_key/" "$DESTINATION_FOLDER/llm/llm.py" 
else
    # Linux version
    sed -i "s/^provider: google/provider: ${CLIENT_NAME_FORMATTED}_google/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    sed -i "s/en_US: Google/en_US: ${CLIENT_NAME_FORMATTED} Google/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    #sed -i "s/Google's Gemini model./${CLIENT_NAME_FORMATTED} Google's Gemini model./" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    sed -i "s/google_api_key/${CLIENT_NAME_FORMATTED}_google_api_key/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_google.yaml"
    sed -i "s/google_api_key/${CLIENT_NAME_FORMATTED}_google_api_key/" "$DESTINATION_FOLDER/llm/llm.py" 
fi

# Confirmar que la copia fue exitosa
if [ $? -eq 0 ]; then
  echo "${CLIENT_NAME_FORMATTED}_google"
else  
  exit 1
fi
