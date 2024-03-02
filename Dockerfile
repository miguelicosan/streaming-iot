# Usa la imagen base de Debian
FROM debian:latest

# Actualiza el índice de paquetes, instala nano, telnet y mosquitto-clients, y limpia
RUN apt-get update && \
    apt-get install -y \
    nano \
    telnet \
    ncat \
    bc \
    mosquitto \
    mosquitto-clients && \
    rm -rf /var/lib/apt/lists/*

# Copia el script de sensores al contenedor
COPY --chmod=755 ./scripts/sensores.sh /sensores.sh

# Otorga permisos de ejecución al script
RUN chmod +x /sensores.sh

# Esperar 5 segundos antes de ejecutar sensores.sh
CMD ["/bin/bash", "-c", "sleep 5 && /sensores.sh"]
