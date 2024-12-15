# Arquitetura

## Estrutura de pastas

- .env (arquivo de variáveis de ambiente)
- docker-compose.yml (arquivo de configuração do docker)
- backend
    - backend.dockerfile (arquivo de configuração do docker)
    - backend.dockerfile.dockerignore (arquivo de configuração dos arquivos que não serão copiados para o container)
    - ... demais arquivos do backend
- frontend
    - frontend.dockerfile (arquivo de configuração do docker)
    - nginx.conf (arquivo de configuração do nginx)
    - ... demais arquivos do frontend

## Containers

O projeto é composto por três containers, dois de serviços e um de banco de dados.

- **backend**: Container em python flask que expõe uma API REST para o frontend.
- **frontend**: Container em react que consome a API REST do backend.
- **db**: Container em postgres que armazena os dados da aplicação.

Foram criados duas redes para comunicação entre os containers, uma para os containers de serviços e outra para o container de banco de dados, sendo o container de backend no meio das duas redes.

- **backend_network**: Rede para comunicação entre os containers de serviços.
- **db_network**: Rede para comunicação entre o container de banco de dados e o container de backend.

## Load Balancing e Escalabilidade

A escalabilidade em um projeto docker-compose não é muito flexível, para tanto foi definido que o container de backend será replicado em 3 instâncias, com o nginx se encarregando de fazer o load balancing entre as instâncias.

Para tanto, no arquivo de configuração do nginx definimos a porta 4000 como a porta de entrada para o backend e configuramos o upstream para as três instâncias do backend (5000, 5001 e 5002).

## Persistência de Dados

Para persistir os dados do banco de dados, foi criado um volume no docker-compose.yml que mapeia a pasta /var/lib/postgresql/data do container de banco de dados para o volume do db-data.

# Execução do projeto

Criar arquivo .env na raiz do projeto com as seguintes variáveis de ambiente:

```
POSTGRES_DB=<nome do banco de dados>
POSTGRES_USER=<usuário do banco de dados>
POSTGRES_PASSWORD=<senha do banco de dados>

# A porta em que o frontend será exposto
# Por padrão, a porta 8080 é utilizada
FRONTEND_PORT=8080
```

Executar o comando `docker-compose up --build -d` na raiz do projeto para gerar as imagens e subir os containers.

Caso não haja alteração nas imagens e elas já tenham sido geradas, basta executar o comando `docker-compose up -d` para subir os containers.

Para acessar o frontend, basta acessar `http://localhost:8080` no navegador.

# Manutenabilidade

Para manutenção do projeto, basta alterar os arquivos de configuração dos containers e executar o comando `docker-compose up --build -d` para gerar as novas imagens e subir os containers.

Os serviços são isolados e podem ser alterados sem afetar os demais serviços.

Após a alteração é possível atualizar apenas o serviço que foi alterado, sem a necessidade de reiniciar todos os containers com o comando `docker-compose up -d <nome do serviço>`.