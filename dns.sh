#!/bin/bash

# --- Variáveis de Configuração ---

#API_URL="https://api.lab.aluno.tonanuvem.com"
API_URL="https://ci3tsdwl01.execute-api.us-east-1.amazonaws.com/prod"
REGISTROS_URL="$API_URL/registros"
API_KEY="aluno"
DOMINIO_BASE="aluno.lab.tonanuvem.com"
SUBDOMINIO="INSERIRseuNOME"
ENDERECO_IP=$(curl -s checkip.amazonaws.com)

# Obter o account_id da AWS (ou perguntar o login)
ACCOUNT_ID=$(aws sts get-caller-identity --output text | awk -F'=' '{print $NF}' | awk -F'@' '{print $1}')
if [ -z "$ACCOUNT_ID" ]; then
    echo "Não foi possível obter o account_id da AWS. Verifique suas credenciais."
    echo "Digite seu LOGIN (usado como subdomínio base):"
    read ACCOUNT_ID
fi

SUBDOMINIO="$ACCOUNT_ID"
#SUBDOMINIO="$ACCOUNT_ID.$DOMINIO_BASE"

echo ""
echo " SUBDOMINIO: $SUBDOMINIO"
echo ""

# --- Subdomínios a serem criados ---
SUBS=(admin page ui backend frontend)

# --- POST para o subdomínio raiz (sem prefixo) ---
read -r -d '' JSON_DATA <<EOF
{
  "alias": "$SUBDOMINIO",
  "endereco_ip": "$ENDERECO_IP"
}
EOF

echo "=> POST /registros para $SUBDOMINIO..."
echo "JSON a ser enviado:"
echo "$JSON_DATA"
curl -s -i -X POST -H "Content-Type: application/json" \
     -H "X-API-Key: $API_KEY" \
     -d "$JSON_DATA" "$REGISTROS_URL"

# --- Loop para os subdomínios (admin, etc) ---
for PREFIX in "${SUBS[@]}"; do
  SUB="$PREFIX.$SUBDOMINIO"
  
  read -r -d '' JSON_DATA <<EOF
{
  "alias": "$SUB",
  "endereco_ip": "$ENDERECO_IP"
}
EOF

  echo
  echo "=> POST /registros para $SUB..."
  echo "JSON a ser enviado:"
  echo "$JSON_DATA"
  
  curl -s -i -X POST -H "Content-Type: application/json" \
       -H "X-API-Key: $API_KEY" \
       -d "$JSON_DATA" "$REGISTROS_URL"
done

echo "=> GET /registros para $SUBDOMINIO..."
echo "Verificando registros existentes:"
echo ""
curl -s -i -X GET -H "Content-Type: application/json" -H "X-API-Key: $API_KEY" "$REGISTROS_URL"
echo ""
