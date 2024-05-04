# SRE Project

## Application
It a simple API backend app, that has only `POST` and `GET` method for adding and fetching resources. 

Resources contain two field, `name` and `url`. 

For example, you want to share a resource for `Kubernetes` you can add the `Link` to that resource. 

Sample_

| ID | Name |   URL  |
|----| -----| -------|
| 1  | Kubernetes | https://kubernetes.io/docs/home/ |
| 2  | Git Crypt | https://dev.to/heroku/how-to-manage-your-secrets-with-git-crypt-56ih |


## OPS

- **Pipeline:** 3 jobs in total. Jobs are...
  1.  Update Changelog
  - It will update the `CHANGELOG.md` on each commit with the commit message. 
  2. Test and Deploy
  - It will run a `db instance` in docker container. 
  - Execute the `db-migration` job in docker based `db` instance. 
  - Run the `unit test` for `db connection` and `simple db query`.
  3. Build and Push Docker Image
  - It will `build` the `Dockerfile` and push the image to `dockerhub` repository with last `6 character of the commit hash` as `image tag`.  


- **Deployment:** Used tools like `Docker`, `Kubernetes`, `Helm Chart` and `Helmfile`. Components are..
  1. Application Deployment Chart Using `Helm Chart` and `Helmfile`. 
  2. `Nginx` as Proxy server.
  3. `MySQL` as database.

  Deployment contains 2 files_
  1. `helmfile.yaml`: Application deployment chart.
  2. `helmfile-services.yaml`: MySQL and Nginx deployment chart.

- **Terraform:** A simple terraform configuration for `AWS-S3` and `CloudFront` to access `S3-Object` via `Cloudfront`. 


## How to Run

### Pre-requisites (Install)
1. Kubernetes (Docker-Desktop).
2. Helm.
3. Helmfile.

### Run
  Service deployments_

  
- Execute the command below to check the configurations_
  ```
  helmfile -f helmfile-services.yamk diff
  ```
- To deploy execute command_
  ```
  helmfile -f helmfile-services.yaml sync
  ```

Wait for a while to get the database ready to accept connection_

- Set the latest tag. Images are pushed here_
  https://hub.docker.com/repository/docker/mahin96/sre-project/general
  ```
  export tag=a99f30 
  ```

- Then to check application deployment_

  ```
  helmfile diff
  ```

- To deploy the application_
  ```
  helmfile sync
  ```


## Test Application with API endpoint

- Use the command below to make a `POST` request with resources_

  ```
  curl -X POST \
    http://localhost/api/v1/resource/create \
    -H 'Content-Type: application/json' \
    -d '{
      "name": "Kubernetes",
      "url": "https://kubernetes.io/docs/home/"
  }' ; \
  curl -X POST \
    http://localhost/api/v1/resource/create \
    -H 'Content-Type: application/json' \
    -d '{
      "name": "Git Crypt",
      "url": "https://dev.to/heroku/how-to-manage-your-secrets-with-git-crypt-56ih"
  }'
  ```

- Use the command below to `GET` the resources_

  ```
  curl -X GET http://localhost/api/v1/resource/list
  ```