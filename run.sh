echo ""
echo "Parando todos os containers em execução... evitando conflito de portas..."
docker ps -q | xargs -r docker stop
echo ""
echo "Todos os containers foram parados."

echo ""
echo "Parando o apache..."
sudo systemctl stop httpd
echo ""
echo "Os servicos apache/httpd foram parados."


### EXECUTAR CADDY

docker-compose up -d


### URLs DO PROJETO:

IP=$(curl -s checkip.amazonaws.com)
echo "Aguardando RUNNING (geralmente 1 min)"
while [ "$(docker logs caddy-caddy-1 2>&1 | grep -i running | wc -l)" -eq "0" ]; do
  printf "."
  sleep 1
done

docker exec -ti caddy-caddy-1 curl -X POST localhost:2019/config/admin -H "Content-Type: application/json" -d '{"listen": "tcp/0.0.0.0:2019"}'
echo ""
echo " VERIFICANDO CONFIG DO CADDY:"
echo ""
curl localhost:2019/config

echo "Caddy Pronto."
echo ""
DOMINIO="fiapaws2.aluno.lab.tonanuvem.com"

echo ""
echo ""
echo "Config OK"
echo ""
echo ""
echo " - CADDY MANAGER    : http://$IP:8888/          login: fiap     senha: fiap"
echo "                    : http://frontend.$DOMINIO"
echo ""
echo " - CADDY UI         : http://$IP:8880/"
echo "                    : http://ui.$DOMINIO"
echo ""
echo " - PAGE             : 
echo "                    : http://page.$DOMINIO"
echo ""
