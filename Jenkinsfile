pipeline
{
    agent any
     environment {
        registry = "public.ecr.aws/i4y9b5h8/spm"
    }
    stages{
        stage('Clone'){
        steps{
    
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/MeetManvar/terraform-ecs-ec2.git']]])
        
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
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) public.ecr.aws/i4y9b5h8'
                sh 'docker push public.ecr.aws/i4y9b5h8/spm:latest'
         
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
