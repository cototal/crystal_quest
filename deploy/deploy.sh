scp deploy/docker-compose.yml $1:~/sites/quest
ssh $1 'bash -lc "cd sites/quest && docker-compose up -d"'
