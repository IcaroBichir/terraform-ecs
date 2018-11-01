#!/bin/bash

configure () {
    sed -i "s/AWS_ACCOUNT_ID/${AWS_ACCOUNT_ID}/g" ./deployment/task-definitions/api.json
    eval $(aws ecr get-login --no-include-email --region us-east-1)
}

create_env () {
    cd deployment
    terraform init
    terraform apply --auto-approve
    cd ../
}

compile_application () {
	mvn clean install
	if [ $? -eq 0 ]; then
    	mvn package
    	if [ $? -eq 0 ]; then
            echo "Application compiled"
        else
    	    echo "failed to create maven package." 
        	exit 1
    	fi
    else
        echo "failed to install dependencies."
        exit 1
    fi	
}

build_docker_image () {
    sed -i "s/ENVIRONMENT_SETUP/${ENVIRONMENT_SETUP}/g" ./Dockerfile
    docker build -t "${AWS_ECR_NAME}" .
    if [ $? -eq 0 ]; then
        docker tag "${AWS_ECR_NAME}":latest "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_REGION}".amazonaws.com/"${AWS_ECR_NAME}":latest
        if [ $? -eq 0 ]; then
            docker push "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_REGION}".amazonaws.com/"${AWS_ECR_NAME}":latest
            if [ $? -eq 0 ]; then
                echo "Image builded, tagged and pushed to Amazon Repository"
            else
                exit 1
            fi
        else
            exit 1
        fi
    else
        exit 1
    fi
}

deploy_application () {
	aws ecs update-service \
    --cluster "${AWS_ECS_CLUSTER}" \
    --service "${AWS_ECR_NAME}" \
    --region "${AWS_REGION}" \
    --deployment-configuration maximumPercent=100,minimumHealthyPercent=0 \
    --force-new-deployment
}

show_public_ip () {
    PUBLIC_IP=`aws ec2 describe-instances --region us-east-1 --filters "Name=tag:Name,Values=ecs_instance" --query "Reservations[*].Instances[*].PublicIpAddress" --output text`
    printf "\n\nAccess this endpoint in your browser http://${PUBLIC_IP}:8080/servlet in a few seconds to open the Java application."
}

delete_env () {
    cd deployment
    terraform destroy --auto-approve
}

COMMAND_TO_RUN=$1
ENVIRONMENT_SETUP=$2

case ${COMMAND_TO_RUN} in
    create_and_deploy)
        configure
        create_env
        compile_application
        build_docker_image
        deploy_application
        show_public_ip
        ;;
    configure)
        configure
        ;;
    create_env)
        create_env
        ;;
    build_and_deploy)
        compile_application
        build_docker_image
        deploy_application
        show_public_ip
        ;;
    delete_env)
        delete_env
        ;;
    *)
        echo "############################################"
        echo "Select between create_and_deploy, configure, create_env, build_and_deploy or delete_env"
        echo "############################################"
        exit 1
        ;;
esac