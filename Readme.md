## vault-openldap-auth-method
### Instruction to test

#### start vault18 and vault19
```
docker-compose up -d
```
#### setup openldap docker and popultate it
#### configure ldap auth method on both vault 1.8, vault 1.9

```
./setup.sh
```


#### check ldap login with vault 1.8 works
VAULT_ADDR=http://127.0.0.1:8220 vault login -method=ldap username=akn1

- password: `test`

#### check ldap login with vault 1.9.x 
#### does not work

VAULT_ADDR=http://127.0.0.1:8200 vault login -method=ldap username=akn1

- password: `test`

#### stop
```
docker-compose down
```
