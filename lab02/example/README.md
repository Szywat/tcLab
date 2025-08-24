# Przykładowe zadanie tworzenia i uruchamiania kontenera Docker

Przykładowe zadanie jak stworzyć i uruchomić kontener Docker za pomocą krótkiego skryptu Bash.

---
## Tworzenie prostej aplikacji
Najpierw utworzymy prostą aplikację w Node.js, która będzie symulowała serwer HTTP. W rzeczywistym zadaniu musisz dostosować tę aplikację do wymagań konkretnego zadania.
```bash
mkdir -p demo-node-app
cd demo-node-app

# Tworzymy prosty plik package.json
echo '{
  "name": "demo-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.17.1"
  }
}' > package.json

# Tworzymy prosty plik aplikacji
echo 'console.log("To jest przykładowa aplikacja. W rzeczywistym zadaniu musisz zaimplementować właściwy kod według wymagań.");' > app.js
```

Teraz utworzymy skrypt bash, który:
1. Uruchomi kontener Docker z odpowiednią wersją Node.js
2. Skopiuje pliki aplikacji do kontenera za pomocą docker cp
3. Zainstaluje zależności
4. Uruchomi aplikację
```sh
#!/bin/bash

# Nazwa skryptu: run-node-docker.sh

# Funkcja do wyświetlania informacji o krokach
info() {
  echo -e "\n\033[1;34m[$1]\033[0m $2"
}

# Ustalamy wersję Node.js (dla demonstracji)
NODE_VERSION="14"

info "KONFIGURACJA" "Używam Node.js w wersji $NODE_VERSION"

# Tworzymy i uruchamiamy kontener Docker w trybie detached (w tle)
info "KONTENER" "Tworzę i uruchamiam kontener Docker z Node.js $NODE_VERSION"
CONTAINER_ID=$(docker run -d -p 8080:8080 --name node-demo-container -it node:$NODE_VERSION-alpine tail -f /dev/null)

echo "Utworzono kontener o ID: $CONTAINER_ID"

# Tworzymy katalog w kontenerze
info "STRUKTURA" "Tworzenie katalogu /app w kontenerze"
docker exec $CONTAINER_ID mkdir -p /app

# Kopiujemy pliki aplikacji do kontenera
info "KOPIOWANIE" "Kopiowanie plików aplikacji do kontenera za pomocą docker cp"
docker cp package.json $CONTAINER_ID:/app/
docker cp app.js $CONTAINER_ID:/app/

# Instalujemy zależności wewnątrz kontenera
info "ZALEŻNOŚCI" "Instalacja zależności Node.js wewnątrz kontenera"
docker exec -w /app $CONTAINER_ID npm install

# Uruchamiamy aplikację
info "URUCHOMIENIE" "Uruchamianie aplikacji Node.js w kontenerze"
docker exec -w /app $CONTAINER_ID node app.js

# Na końcu pokazujemy instrukcje jak zatrzymać i usunąć kontener
info "SPRZĄTANIE" "Aby zatrzymać i usunąć kontener, wykonaj:"
echo "docker stop $CONTAINER_ID"
echo "docker rm $CONTAINER_ID"
```
Uruchamianie kontenera:
```sh
CONTAINER_ID=$(docker run -d -p 8080:8080 --name node-demo-container -it node:$NODE_VERSION-alpine tail -f /dev/null)
```
* `-d`: Uruchamia kontener w trybie detached (w tle)
* `-p 8080:8080`: Mapuje port 8080 hosta na port 8080 kontenera
* `--name node-demo-container`: Nadaje kontenerowi nazwę dla łatwiejszej identyfikacji
* -`-it`: Zapewnia interaktywny terminal
* `node:$NODE_VERSION-alpine`: Określa obraz z żądaną wersją Node.js (lekki obraz alpine)
* `tail -f /dev/null`: To polecenie utrzymuje kontener działającym - kontener musi mieć uruchomiony proces, inaczej zatrzyma się automatycznie

Kopiowanie plików za pomocą docker cp
```sh
docker cp package.json $CONTAINER_ID:/app/
docker cp app.js $CONTAINER_ID:/app/
```
Te polecenia kopiują pliki z hosta do kontenera. W przeciwieństwie do montowania wolumenów, które tworzy "tunel" między hostem a kontenerem, `docker cp` wykonuje jednorazowe kopiowanie plików do kontenera. Po skopiowaniu, pliki istnieją niezależnie wewnątrz kontenera i nie są aktualizowane, gdy zmieniają się na hoście.

Wykonywanie poleceń w kontenerze:
```sh
docker exec -w /app $CONTAINER_ID npm install
docker exec -w /app $CONTAINER_ID node app.js
```
* `docker exec`: Wykonuje polecenie w działającym kontenerze
* `-w /app`: Ustawia katalog roboczy na `/app` przed wykonaniem polecenia
* `$CONTAINER_ID`: Identyfikator kontenera, w którym chcemy wykonać polecenie
* `npm install`: Instaluje zależności zdefiniowane w package.json
* `node app.js`: Uruchamia aplikację