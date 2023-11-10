#!/bin/bash

# Obtener la fecha y hora actual
current_date=$(date +"%d-%m-%Y_%H-%M")

# Paso 1: Levantar el contenedor de MongoDB
docker run --name mongo_backup -d mongo

# Paso 2: Ejecutar el comando mongodump dentro del contenedor y proporcionar la contraseña a través de un archivo de configuración
cat <<EOF > config.conf
password: "inpXxvwuzEImF3g0j0zw"
uri: "mongodb://mongo:inpXxvwuzEImF3g0j0zw@containers-us-west-27.railway.app:7431"
sslPEMKeyPassword: ""
destinationPassword: ""
EOF
docker cp config.conf mongo_backup:/config.conf
docker exec -i mongo_backup mongodump --config /config.conf
# Eliminar el archivo de configuración
rm config.conf

# Paso 3: Copiar la carpeta de backup a la máquina host (la maquina host debe tener creada la capeta dentro de la carpeta personal backups_Cobranza)
docker cp mongo_backup:/dump ./backups_Cobranza/backup_$current_date

# Paso 4: Destruir el contenedor
docker stop mongo_backup
docker rm mongo_backup

# Paso 5: Automatizar tarea
#ej: Todos los dias a las 23:00
# 00 23 * * * /bin/bash /home/gtiseira/Dev/bash/cobranzaDante_backups.sh



# Para hacer un restore de db
# tener el dump y luego
# mongorestore --uri="mongodb://mongo:-4hg54c65bdad34h3aADecd4cgfEcE4-@monorail.proxy.rlwy.net:17634" --drop ./dump

