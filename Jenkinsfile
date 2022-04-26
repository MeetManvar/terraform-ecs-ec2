pipeline
{
    agent any
     environment {
        registry = "133631580572.dkr.ecr.us-east-1.amazonaws.com/repoforecr"
    }
    stages{
        stage('Clone'){
        steps{
    
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/techay-mihir-simform/terraform_backend.git']]])
        
        }   
         }
        stage('Build')
        {
            steps{
                script {
                        dockerImage = docker.build registry
                        }
            }
        }
        stage('Push to ECR'){
            steps{
                script {
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 133631580572.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker push 133631580572.dkr.ecr.us-east-1.amazonaws.com/repoforecr:latest'
         
         }
            }
        }
          stage('New_task'){
              steps{
                  sh '''
                  ls -al
                  aws --version
                  aws ecs register-task-definition --cli-input-json file://./container-def-cli.json 
                  '''
              }
          }  
          stage('Update_service'){
              steps{
                  sh '''
                  aws ecs update-service --cluster ecscluster --service web-service1 --task-definition web-family --force-new-deployment
                  '''
              }
          }
        
    }
}
