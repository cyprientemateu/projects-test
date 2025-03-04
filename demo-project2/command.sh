docker run -d --name database \
  --restart always \
  -e MYSQL_ROOT_PASSWORD=abc123 \
  -e MYSQL_DATABASE=openSIS \
  -e MYSQL_USER=openSIS_rw \
  -e MYSQL_PASSWORD=Op3nS!S \
  -v db_data:/var/lib/mysql \
  -v $(pwd)/mysql-init:/docker-entrypoint-initdb.d \
  -v $(pwd)/mysql-config/strict_mode.cnf:/etc/mysql/conf.d/strict_mode.cnf \
  --network opensis_network \
  --network-alias opensis \
  mariadb:10.5




docker run -d --name frontend \
  -p 8080:80 -p 80:80 \
  --network opensis_network \
  --network-alias opensis \
  --depends-on database \
  your-frontend-image


docker network create opensis_network
docker volume create db_data
docker volume create openSIS


docker build -t your-frontend-image .

https://mxulises.medium.com/simple-prometheus-setup-on-docker-compose-f702d5f9857
