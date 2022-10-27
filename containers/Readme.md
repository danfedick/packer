
# Packer build command example

```bash  
packer build \
  --var dockerhub_username="danfedick" \
  --var dockerhub_password=$DOCKER_PASSWORD \
  --var push_repo=danfedick/nginx:latest \
  ./nginx.pkr.hcl
```
