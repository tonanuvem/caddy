echo ""
echo "Parando todos os containers em execução... evitando conflito de portas..."
docker ps -q | xargs -r docker stop
echo ""
echo "Todos os containers foram parados."


### EXECUTAR CADDY

docker-compose up -d


### URLs DO PROJETO:

IP=$(curl -s checkip.amazonaws.com)
#echo "Aguardando TOKEN (geralmente 1 min)"
#while [ "$(docker logs datacatalog-automl-1 2>&1 | grep token | grep 127. | grep NotebookApp | wc -l)" != "1" ]; do
#  printf "."
#  sleep 1
#done
echo "Caddy Pronto."
echo ""

echo ""
echo ""
echo "Config OK"
echo ""
echo ""
echo " - CADDY      : http://$IP:3000/          login: fiap     senha: fiap"
echo ""
