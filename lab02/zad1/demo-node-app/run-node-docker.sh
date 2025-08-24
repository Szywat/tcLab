#!/bin/bash

# Nazwa skryptu: run-node-docker.sh

# Funkcja do wyświetlania informacji o krokach
info() {
    echo -e "\n\033[1;34m[$1]\033[0m $2"
}

# Ustalamy wersję Node.js (dla demonstracji)
NODE_VERSION="12"

info "KONFIGURACJA" "Używamy Node.js w wersji $NODE_VERSION"

# Tworzymy i uruchamiamy kontener Docker w trybie detached (w tle)
info "KONTENER" "Tworzę i uruchamiam kontener Docker z Node.js $NODE_VERSION"
CONTAINER_ID=$(docker run -d -p 8080:8080 --name zadanie1-container node:$NODE_VERSION-alpine tail -f /dev/null)

echo "Utworzono kontener o ID: $CONTAINER_ID"

# Tworzymy katalog w kontenerze
info "STRUKTURA" "Tworzenie katalogu /app w kontenerze"
docker exec $CONTAINER_ID mkdir -p /app

# Kopiujemy pliki w aplikacji do kontenera
info "KOPIOWANIE" "Kopiowanie plików aplikacji do kontenera za pomocą docker cp"
docker cp package.json $CONTAINER_ID:/app/
docker cp app.js $CONTAINER_ID:/app/

# Instalujemy zależności wewnątrz kontenera
info "ZALEŻNOŚCI" "Instalacja zależności Node.js wewnątrz kontenera"
docker exec -d -w /app $CONTAINER_ID npm install

# Uruchamiamy aplikację
info "URUCHOMIENIE" "Uruchamianie aplikacji Node.js w kontenerze"
docker exec -d -w /app $CONTAINER_ID node app.js

# Na końcu pokazujemy instrukcję jak zatrzymać i usunąć kontener
info "SPRZĄTANIE" "Aby zatrzymać i usunąć kontener, wykonaj:"
echo "docker stop $CONTAINER_ID"
echo "docker rm $CONTAINER_ID"
