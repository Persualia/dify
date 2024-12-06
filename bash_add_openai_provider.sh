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
SOURCE_FOLDER="./api/core/model_runtime/model_providers/openai"
# Convertir el nombre del cliente a minúsculas y reemplazar espacios con guiones bajos
CLIENT_NAME_FORMATTED=$(echo "$CLIENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Ruta al directorio donde quieres hacer la copia
DESTINATION_FOLDER="./api/core/model_runtime/model_providers/${CLIENT_NAME_FORMATTED}_openai"

# Crear el directorio de destino si no existe
mkdir -p "$DESTINATION_FOLDER"

# Copiar los archivos
cp -R "$SOURCE_FOLDER/" "$DESTINATION_FOLDER"

# Renombrar el archivo google.py
mv "$DESTINATION_FOLDER/openai.py" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.py"
mv "$DESTINATION_FOLDER/openai.yaml" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"


# Modificar el contenido del archivo YAML
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version
    sed -i '' "s/^provider: openai/provider: ${CLIENT_NAME_FORMATTED}_openai/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i '' "s/en_US: OpenAI/en_US: ${CLIENT_NAME_FORMATTED} OpenAI/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i '' "s/Models provided by OpenAI./${CLIENT_NAME_FORMATTED} Models provided by OpenAI./" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i '' "s/openai_api_key/${CLIENT_NAME_FORMATTED}_openai_api_key/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"    
    sed -i '' "s/openai_api_base/${CLIENT_NAME_FORMATTED}_openai_api_base/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"    
    sed -i '' "s/openai_organization/${CLIENT_NAME_FORMATTED}_openai_organization/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"    
    
    sed -i '' "s/openai_api_key/${CLIENT_NAME_FORMATTED}_openai_api_key/" "$DESTINATION_FOLDER/_common.py" 
    sed -i '' "s/openai_api_base/${CLIENT_NAME_FORMATTED}_openai_api_base/g" "$DESTINATION_FOLDER/_common.py" 
    sed -i '' "s/openai_organization/${CLIENT_NAME_FORMATTED}_openai_organization/" "$DESTINATION_FOLDER/_common.py" 

    sed -i '' "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/llm/llm.py"
    sed -i '' "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/moderation/moderation.py"
    sed -i '' "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/speech2text/speech2text.py"
    sed -i '' "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/text_embedding/text_embedding.py"
    sed -i '' "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/tts/tts.py"
else
    # Linux version
    sed -i "s/^provider: openai/provider: ${CLIENT_NAME_FORMATTED}_openai/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i "s/en_US: OpenAI/en_US: ${CLIENT_NAME_FORMATTED} OpenAI/" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i "s/Models provided by OpenAI./${CLIENT_NAME_FORMATTED} Models provided by OpenAI./" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_opemai.yaml"
    sed -i "s/openai_api_key/${CLIENT_NAME_FORMATTED}_openai_api_key/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i "s/openai_api_base/${CLIENT_NAME_FORMATTED}_openai_api_base/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    sed -i "s/openai_organization/${CLIENT_NAME_FORMATTED}_openai_organization/g" "$DESTINATION_FOLDER/${CLIENT_NAME_FORMATTED}_openai.yaml"
    
    sed -i "s/openai_api_key/${CLIENT_NAME_FORMATTED}_openai_api_key/g" "$DESTINATION_FOLDER/_common.py" 
    sed -i "s/openai_api_base/${CLIENT_NAME_FORMATTED}_openai_api_basey/g" "$DESTINATION_FOLDER/_common.py" 
    sed -i "s/openai_organization/${CLIENT_NAME_FORMATTED}_openai_organization/g" "$DESTINATION_FOLDER/_common.py" 

    sed -i "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/llm/llm.py"
    sed -i "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/moderation/moderation.py"
    sed -i "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/speech2text/speech2text.py"
    sed -i "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/text_embedding/text_embedding.py"
    sed -i "s/.openai._common/.${CLIENT_NAME_FORMATTED}_openai._common/" "$DESTINATION_FOLDER/tts/tts.py"
fi

# Confirmar que la copia fue exitosa
if [ $? -eq 0 ]; then
  echo "${CLIENT_NAME_FORMATTED}_openai"
else  
  exit 1
fi
