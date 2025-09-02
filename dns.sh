# --- Variáveis de Configuração ---
# Substitua 'SENHA' pela sua chave de API, se for diferente.
API_KEY="SENHA"
# URL base da sua API Gateway.
API_URL="https:/api.lab.aluno.tonanuvem.com"
# URLs completas para os endpoints.
REGISTROS_URL="$API_URL/registros"
INFO_URL="$API_URL/info"
# Cria um subdomínio único usando a data e hora atuais.
# Isso evita que o teste falhe se você rodar o script várias vezes.
#SUBDOMINIO="teste-api-$(date +%s)"

SUBDOMINIO="INSERIRseuNOME"
ENDERECO_IP=$(curl checkip.amazonaws.com)

# --- JSON para o teste de POST ---
# O 'heredoc' (<<EOF) permite definir um bloco de texto JSON no próprio script.
# A variável "$SUBDOMINIO" é expandida para o valor único que criamos acima.
read -r -d '' JSON_DATA <<EOF
{
  "subdominio": "$SUBDOMINIO",
  "endereco_ip": "$ENDERECO_IP"
}
EOF

# --- Teste POST /registros ---
# Comando curl:
# -X POST: Define o método HTTP como POST.
# -H "Content-Type: application/json": Informa que o corpo da requisição é JSON.
# -d "$JSON_DATA": Envia o conteúdo da nossa variável 'JSON_DATA' no corpo da requisição.
echo "=> Testando POST /registros..."
echo "JSON a ser enviado: "
echo "$JSON_DATA"
curl -s -i -X POST -H "Content-Type: application/json" -H "X-API-Key: $API_KEY" -d "$JSON_DATA" "$REGISTROS_URL"
