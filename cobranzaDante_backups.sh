#!/bin/bash

# Obtener la fecha y hora actual
current_date=$(date +"%d-%m-%Y_%H-%M-%S")

# Paso 1: Levantar el contenedor de MongoDB
docker run --name mongo_backup -d mongo

# Paso 2: Ejecutar el comando mongodump dentro del contenedor y proporcionar la contraseña a través de un archivo de configuración
cat <<EOF > config.conf
password: "<MONGOPASSWORD>"
uri: "<MONGO_URL>"
sslPEMKeyPassword: ""
destinationPassword: ""
EOF
docker cp config.conf mongo_backup:/config.conf
docker exec -i mongo_backup mongodump --config /config.conf
# Eliminar el archivo de configuración
rm config.conf

# Paso 3: Copiar la carpeta de backup a la máquina host
docker cp mongo_backup:/dump ./backup_$current_date

# Paso 4: Destruir el contenedor
docker stop mongo_backup
docker rm mongo_backup