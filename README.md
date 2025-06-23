✅ README.md
# iGPS Docker Image

This repository contains a Docker image setup with **Nginx**, **PHP-FPM 7.3**, and **Supervisor**, designed to run custom PHP applications efficiently.

## 📦 Included Features

- Nginx web server
- PHP 7.3 with common extensions
- Supervisor to run both services in one container
- Support for custom PHP and Nginx configurations

---

## 🛠️ Build the Docker Image

Clone the repository and build the image:

git clone https://github.com/BernardtB/igps
cd igps
docker build --no-cache -t igps .

---

## 🚀 Run the Container

docker run -d \
  --name igps-core \
  -p 8081:80 \
  --mount type=bind,source="/Users/bernardtbouillon/new test/test2",target=/var/www/html \
  igps

---
  
## 🔍 Explanation of --mount Option

type=bind — Binds a local directory from your host machine into the container.

source=/Users/bernardtbouillon/new test/test2 — This is your local folder that contains your website files (like index.php, etc.).

target=/var/www/html — This is where Nginx will look for the web files inside the container.

Any changes made to the files in your local source folder will instantly reflect inside the container without needing to rebuild the image.

---

## ✅ Access the App
Once the container is running, open your browser and go to:

http://localhost:8081
You should see your PHP application running.

---

## 🧹 Stop and Remove the Container

docker stop igps-core
docker rm igps-core

---

## 📁 Directory Structure

igps/

├── Dockerfile

├── supervisord.conf

├── nginx/

│   └── default.conf

├── php/

│   └── custom.ini

├── www/

│   └── index.php


---

## 👤 Maintainer
Bernardt Bouillon

## For a all in one script
git clone https://github.com/BernardtB/igps
mkdir website
cd igps
docker build --no-cache -t igps-php7.3.33-nginx-fpm-v1 .
docker run -d \
  --name igps-core \
  -p 8081:80 \
  --mount type=bind,source="$(pwd)/../website",target=/var/www/html \
  igps-php7.3.33-nginx-fpm-v1
