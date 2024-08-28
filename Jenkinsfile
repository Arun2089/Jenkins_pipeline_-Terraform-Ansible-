pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
        AWS_DEFAULT_REGION = credentials('aws_default_region')
    }

    stages {
        stage('Checkout') {
            steps {
               
                git branch: 'main', url: 'https://github.com/Arun2089/Task_jenkins_pipeline.git'
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                   
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                   
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('Run Script') {
            steps {
                dir('terraform') {
                   
                    sh 'bash script.sh'
                }
            }
        }
        
        stage('Wait') {
            steps {
               
                sleep time: 10, unit: 'SECONDS'
            }
        }
        
        stage('Ansible Playbook') {
            steps {
                dir('Ansible') {
                   
                    sh 'ansible-playbook -i hosts playbook.yml'
                }
            }
        }
    }

   
}
