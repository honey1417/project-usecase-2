pipeline {
    agent any 
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-creds')
        SQL_PASSWORD = credentials('sql-db-creds')
        PROJECT_ID = "harshini-450807"
        REGION = "us-east1"
    }
    tools {
        git 'Git'
    }
    stages {
        stage ('Test Git Command') {
            steps {
                sh "git --version"
            }
        }
        stage ('Checkout Code') {
            steps {
                echo 'Cloning Repository....'
                git branch: 'main', url: 'https://github.com/honey1417/project-usecase-2.git'
            }
        }
        stage ('Authenticating with GCP') {
            steps {
                script {
                    echo 'Authenticating with GCP....'
                    sh 'gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}'
                    sh 'gcloud config set project ${PROJECT_ID}'
                }
            }
        }
        stage ('Terraform Init') {
            steps {
                script {
                    echo 'Initializing Terraform....'
                    sh 'terraform init'
                }
            }
        }
       stage ('Terraform Plan') {
            steps {
                script {
                    echo 'Planning Terraform....'
                    withCredentials([string(credentialsId: 'sql-db-creds', variable: 'SQL_PASSWORD')]) {
                        sh 'terraform plan -var="db_password=${SQL_PASSWORD}"'
                    }
                }
            }
        }

        stage ('Terraform Apply') {
            steps {
                script {
                    echo 'Applying Terraform....'
                    withCredentials([string(credentialsId: 'sql-db-creds', variable: 'SQL_PASSWORD')]) {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        stage('Retrieve Load Balancer & MySQL Details') {
            steps {
                script {
                    echo 'Fetching Load Balancer IP...'
                    sh 'gcloud compute forwarding-rules list --format="table(name, IPAddress)"'

                    echo 'Fetching MySQL DB Info...'
                    sh 'gcloud sql instances describe usecase-2-sql-instance --format="table(name, ipAddresses[0].ipAddress, databaseVersion)"'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed. Check logs for errors.'
        }
    }
}