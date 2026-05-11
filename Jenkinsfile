pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub branch/PR..."
                checkout scm
            }
        }

        stage('Terraform Format Check') {
            steps {
                echo "Checking Terraform formatting..."
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform backend and providers..."
                sh 'terraform init -reconfigure'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Creating Terraform execution plan..."
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                echo "Running Terraform apply only on master branch..."
                input message: 'Approve Terraform Apply to AWS?'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }

        failure {
            echo "Pipeline failed. Please check the logs."
        }

        always {
            echo "Cleaning Terraform plan file if exists..."
            sh 'rm -f tfplan || true'
        }
    }
}