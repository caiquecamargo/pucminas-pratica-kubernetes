# Documentação

## Informações gerais

- **Nome**: Caique de Camargo
- **Matrícula**: 217240
- **Repositório**: https://github.com/caiquecamargo/pucminas-pratica-kubernetes

## Estrutura de pastas

- backend
    - dockerfile (arquivo de configuração do docker)
    - .dockerignore (arquivo de configuração dos arquivos que não serão copiados para o container)
    - ... demais arquivos do backend
- frontend
    - dockerfile (arquivo de configuração do docker)
    - ... demais arquivos do frontend
- k8s
    - backend-configmap.yaml (configuração do configmap do backend)
    - backend-deployment.yaml (configuração do deployment e demais serviços do backend)
    - db-configmap.yaml (configuração do configmap do banco de dados)
    - db-deployment.yaml (configuração do deployment e demais serviços do banco de dados)
    - frontend-configmap.yaml (configuração do configmap do frontend)
    - frontend-deployment.yaml (configuração do deployment e demais serviços do frontend)

Desses arquivos, apenas os que se encontram na pasta `k8s` são necessários para o funcionamento da aplicação, mas vale deixar os demais arquivos como documentação de tudo o que foi feito.

## Arquitetura

### Frontend

O Frontend é o mesmo container utilizado no projeto mas com algumas pequenas adequações. Retiramos o nginx.conf e agora o utilizamos como um ConfigMap no kubernetes.

Por arquitetura temos:
- A imagem do backend hospedada no DockerHub: `caiquedecamargo/pucminas-frontend:latest`
- Um ConfigMap que provê o arquivo de configuração do nginx
- Um Deployment que cria um pod com a imagem do frontend que expoõe a porta 80 do container para o cluster e o ConfigMap do nginx
- Um Service que expõe o pod do Deployment para o Cluster

### Backend

O Backend utiliza a imagem do backend hospedada no DockerHub: `caiquedecamargo/pucminas-backend:latest`

Por arquitetura temos:
- A imagem do backend hospedada no DockerHub: `caiquedecamargo/pucminas-backend:latest`
- Um ConfigMap com as configurações das variáveis de ambiente próprias do backend
- Um Deployment com as configurações do container e também mais algumas variáveis de ambiente reaproveitadas do ConfigMap do `db`
- Um Service que expõe a porta 5000 do Deployment para o Cluster
- Um HPA que escala o Deployment do backend para até 10 instâncias quando a média de uso da CPU estiver acima de 50%

### Banco de Dados

O Banco de Dados utiliza a imagem do postgres: `postgres:latest`

Por arquitetura temos:
- Um ConfigMap com as configurações do banco de dados
- Um StatefulSet com as configurações junto de um PersistentVolume.
- Um Service que expõe a porta 5432 do StatefulSet para o Cluster

# Execução do projeto

Executar os comando na ordem abaixo:

```bash
kubectl apply -f k8s/db-configmap.yaml
kubectl apply -f k8s/db-deployment.yaml
kubectl apply -f k8s/backend-configmap.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/frontend-configmap.yaml
kubectl apply -f k8s/frontend-deployment.yaml
```

Para acessar o frontend:
- Se estiver utilizando o docker-desktop, o IP é localhost `http://localhost:30008`
- Se estiver utilizando o minikube, o IP é o IP do minikube `minikube ip` e a porta 30008 `http://<minikube-ip>:30008`

# Limpeza do projeto

Executar os comando na ordem abaixo:

```bash
kubectl delete -f k8s/frontend-deployment.yaml
kubectl delete -f k8s/frontend-configmap.yaml
kubectl delete -f k8s/backend-deployment.yaml
kubectl delete -f k8s/backend-configmap.yaml
kubectl delete -f k8s/db-deployment.yaml
kubectl delete -f k8s/db-configmap.yaml
```