# Microservices Deployment on Amazon EKS using Docker and Terraform

![Mircoservice EKS TF banner](/screenshots/microservice-eks-tf.png)


### Overview:

Demonstrate the deployment of a microservices architecture on Amazon Elastic Kubernetes Service (EKS) using Docker for containerization and Terraform for provisioning AWS resources. A complete workflow for deploying microservices on a highly scalable Kubernetes cluster using modern DevOps tools.

### Key Technologies:

-   **Microservices Architecture:**  The application is broken down into independent, loosely coupled microservices for improved maintainability and scalability.
-   **Docker:**  Used for containerizing the microservices, ensuring consistent and reproducible environments across development, testing, and production environments.
-   **Terraform:**  An Infrastructure as Code (IaC) tool used for provisioning and managing the necessary AWS resources, such as EKS clusters, load balancers, and other supporting services.
-   **Amazon EKS:**  A fully managed Kubernetes service provided by Amazon Web Services (AWS), used for deploying and managing the microservices on a highly available and scalable infrastructure.
> **CI/CD Integration:** Integration with CI/CD pipelines such as Jenkins or GitHub Actions can be easily implemented to automate the deployment process, further enhancing the efficiency of the development workflow.

### Deployment Process

**Containerization**: Each microservice is containerized using Docker, ensuring consistent and reproducible environments across different stages of the deployment pipeline.

 **Docker Hub**: The Docker images are pushed to Docker Hub, a centralized repository for storing and distributing container images.


```bash
#Clone this git repo
#To build and push docker images
chmod +x docker-build-push.sh
./docker-build-push.sh
```

![Docker Hub all rep](/screenshots/docker-hub.png)


**Full Script for Build and Push docker images:**
```bash
#!/bin/bash

# Navigate to the directory containing the script
cd "$(dirname "$0")" || exit

# Docker Hub username
DOCKER_USERNAME="akiltipu"

# List all directories containing Dockerfile
services=$(find . -mindepth 2 -type f -name Dockerfile | xargs -n1 dirname | sort -u)

# Build and push each Docker image in its respective directory
for service in $services; do
    echo "Building Docker image in $service"
    cd "$service" || exit
    service_name=$(basename "$service")
    docker build -t "$service_name" .
    docker tag "$service_name" "$DOCKER_USERNAME/$service_name"
    docker push "$DOCKER_USERNAME/$service_name"
    cd - || exit
done
```

**Infrastructure Provisioning**: Terraform is used to provision the necessary AWS resources, including the EKS cluster, node groups, and any additional services required by the application.

```bash
# Ensure you have Terraform installed and configured properly
# Change directory to where your Terraform configuration files are located
cd terraform

# Initialize Terraform in the current directory
terraform init

# Display an execution plan to understand what Terraform will do
terraform plan

# Apply the changes required to reach the desired state of the configuration
terraform apply

# Output the values you might need after provisioning
echo "Output values:"
terraform output

# If everything is set up correctly and you want to clean up resources, you can run:
terraform destroy

# Reminder: Ensure you understand the implications of running 'terraform destroy'
# It will remove all resources defined in your Terraform configuration, including EKS cluster and associated resources.

```

![Terraform complete status](/screenshots/tf-final.png)

 **Kubernetes Deployment**: The microservices are deployed to the EKS cluster using Kubernetes manifests. These manifests define the desired state of the application, including replicas, resource requests, and service configurations.
```bash
# Ensure you have the AWS CLI and kubectl installed, and Terraform has provisioned the EKS cluster
# Change directory to where your Kubernetes configuration files are located
cd kubernetes

# Update kubeconfig to configure kubectl to use the EKS cluster
# Replace 'eks_cluster_name' with the actual name of your EKS cluster
aws eks update-kubeconfig --region us-east-1 --name eks_cluster_name

# Displaying Kubernetes pods before applying configurations
kubectl get pods --all-namespaces

# Apply the Kubernetes configurations from the YAML file
kubectl apply -f all-service-deployment.yaml

# Displaying Kubernetes pods after applying configurations
kubectl get pods --all-namespaces

# Delete Kubernetes resources if needed  
# Delete all resources defined in all-service-deployment.yaml  
# kubectl delete -f all-service-deployment.yaml

```
![Eks cluster creating](/screenshots/eks-cluster.png)

**Load Balancing**: Kubernetes services and Amazon Elastic Load Balancing (ELB) are used to distribute traffic across multiple replicas of each microservice, ensuring high availability and scalability.

**See the App on Amazon Elastic Load Balancer Endpoint that is automatically created.**


![Final app on ELB](/screenshots/app-on-elb.png)

