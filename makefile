project_name=molcrafts
docker-build :
  docker build -f builder.Dockerfile -t $(project_name)-dev:latest .

docker-run :
  docker run -it --rm -v $(project_name)-dev:latest /bin/bash