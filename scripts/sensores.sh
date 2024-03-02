#!/bin/bash

# Espera a que iot-mosquitto esté disponible en el puerto 1883
until ncat -z iot-mosquitto 1883; do
    echo "Esperando a que iot-mosquitto esté disponible en el puerto 1883..."
    sleep 1
done

echo "iot-mosquitto está disponible. Iniciando el envío de datos..."

# Inicializar valores iniciales para humedad, presión y temperatura de cada sensor
declare -A humedad presion temperatura

# Establecer valores iniciales para cada sensor
for ((i=1; i<=5; i++)); do
    humedad[$i]=50    # Valor inicial medio para humedad
    presion[$i]=1000  # Valor inicial medio para presión
    temperatura[$i]=25 # Valor inicial medio para temperatura
done

# Bucle infinito para enviar datos continuamente
while true; do
    echo "Simulando datos de todos los sensores"
    echo "------------------------------------"
    
    for ((i=1; i<=5; i++)); do
        # Ajustar humedad de manera aleatoria: subir 0.5, bajar 0.5 o quedarse igual
        ajuste_humedad=$((RANDOM % 3 - 1))  # -1, 0, 1
        humedad[$i]=`echo "${humedad[$i]} + $ajuste_humedad * 0.5" | bc`
        
        # Ajustar presión de manera aleatoria: subir 50, bajar 50 o quedarse igual
        ajuste_presion=$((RANDOM % 3 - 1))  # -1, 0, 1
        presion[$i]=`echo "${presion[$i]} + $ajuste_presion * 50" | bc`
        
        # Ajustar temperatura de manera aleatoria: subir 0.5, bajar 0.5 o quedarse igual
        ajuste_temperatura=$((RANDOM % 3 - 1))  # -1, 0, 1
        temperatura[$i]=`echo "${temperatura[$i]} + $ajuste_temperatura * 0.5" | bc`
        
        # Mostrar los valores que se están enviando para cada sensor
        echo "Sensor $i - Humedad: ${humedad[$i]}, Presión: ${presion[$i]}, Temperatura: ${temperatura[$i]}"
        
        # Publicar los valores en los respectivos tópicos para cada sensor
        mosquitto_pub -h iot-mosquitto -t "sensor-$i/humedad" -m "${humedad[$i]}"
        mosquitto_pub -h iot-mosquitto -t "sensor-$i/presion" -m "${presion[$i]}"
        mosquitto_pub -h iot-mosquitto -t "sensor-$i/temperatura" -m "${temperatura[$i]}"
    done
    
    # Esperar 1 segundo antes del próximo ciclo
    sleep 1
done