cd /opt/app/netology2026-05-virt-05-docker-swarm-task-01
docker build -t fastapi-app:latest -f Dockerfile.python .
docker stack deploy -c compose.yaml test-app


#проверка
docker stack ls
docker stack services test-app
docker service ps test-app_web
docker node ls
