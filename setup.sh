# setup openldap
docker run \
  --detach \
  --rm \
  --env LDAP_ORGANISATION="Vaultron" \
  --env LDAP_DOMAIN="vaultron.waves" \
  --env LDAP_ADMIN_PASSWORD="vaultron" \
  --ip 172.16.238.3 \
  --name vaultron-openldap \
  --network testing_net \
  -p 389:389 \
  -p 636:636 \
  osixia/openldap:latest

# sleep for 10 sec
sleep 10

# populate ldap
ldapadd -cxD "cn=admin,dc=vaultron,dc=waves" -f ./ldap/vaultron.ldif -w vaultron
ldapadd -cxD "cn=admin,dc=vaultron,dc=waves" -f ./ldap/vaultron1.ldif -w vaultron
ldapadd -cxD "cn=admin,dc=vaultron,dc=waves" -f ./ldap/vaultron2.ldif -w vaultron
ldapadd -cxD "cn=admin,dc=vaultron,dc=waves" -f ./ldap/vaultron3.ldif -w vaultron

# config vault 1.8
export VAULT_TOKEN=root
export VAULT_ADDR=http://127.0.0.1:8220
vault auth enable ldap
vault write auth/ldap/config \
  url="ldap://172.16.238.3" \
  userdn="ou=users,dc=vaultron,dc=waves" \
  groupdn="ou=groups,dc=vaultron,dc=waves" \
  groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
  groupattr="cn" \
  starttls=false \
  binddn="cn=admin,dc=vaultron,dc=waves" \
  bindpass="vaultron"

# config vault 1.9
export VAULT_ADDR=http://127.0.0.1:8200
vault auth enable ldap

vault write auth/ldap/config \
  url="ldap://172.16.238.3" \
  userdn="ou=users,dc=vaultron,dc=waves" \
  groupdn="ou=groups,dc=vaultron,dc=waves" \
  groupfilter="(|(memberUid={{.Username}})(member={{.UserDN}})(uniqueMember={{.UserDN}}))" \
  groupattr="cn" \
  starttls=false \
  binddn="cn=admin,dc=vaultron,dc=waves" \
  bindpass="vaultron"
