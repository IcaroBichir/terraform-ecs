# Project overview

This project creates a brand new environment in AWS using a EC2 configured in a ECS cluster, running a Java servlet API that shows the running environment parameter, containerized in Docker and protected by AWS Security Groups with less privileges policies. The infrastructure is automated created by a Terraform recipe, using the best practices and clean code.
A bash script is responsible to handle all execution commands:
- Environment variables settings
- Terraform environment creation
- Java package installation and packaging
- Docker image creation, tagging and pushing 
- Application deployment with desirable environment
- Terraform environment deletion.

# Requirements

To properly execute the project, please make sure that you have the following applications and configurations:

- AWS account ID number
- AWS command line interface installed and configured
- Java (version 8 or superior)
- Maven (version 3.5.4 or superior)
- Terraform (version 0.11.8 or superior)
- Docker (version 18 or superior)
- Bash (native in Linux/Unix)

# How to execute

``This project was configured to run in us-east-1 region with default aws cli credentials.``

To create the environment, build the application and deploy your docker to AWS, get your AWS account ID number and execute this tree commands in your terminal with your environment choice:
```
export AWS_ACCOUNT_ID=
. ./variables.sh
./build_deploy.sh create_and_deploy dev|stage|prod
```
In the end, you will get the endpoint to access in your browser and see what environment is running inside the docker application.

# Optional commands to execute

You can execute each state separately, running the specifics commands bellow:

- To configure environment variables and setup them to creation and deployment, run this commands:
```
export AWS_ACCOUNT_ID=
. ./variables.sh
./build_deploy.sh configure
```

- To create the environment using Terraform recipe, run this command:
```
./build_deploy.sh create_env
```

- To deploy the application, in the desirable environment, run this command:
```
./build_deploy.sh build_and_deploy dev|stage|prod
```

- To delete the environment created by Terraform, run this command:
```
./build_deploy.sh delete_env
```