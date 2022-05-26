pipeline {
    agent {
        label "dev"
    }
    options {
        buildDiscarder logRotator(daysToKeepStr: '5', numToKeepStr: '10')
    }
     environment {
        registryName = "aishacr2"
        registryCredential = 'acr'
        dockerImage = ''
        registryUrl = 'aishacr2.azurecr.io'
        BRANCH_NAME= "${env.BRANCH_NAME}"
    }
    stages {
        stage('get agent') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'prod') {
                        server = 'prod'
                    }
                    else if(env.BRANCH_NAME == 'validate') {
                        server = 'validate'
                    }
                    else {server = 'dev'}
                }
            }
        }
        stage('Compile and Clean') { 
            steps {
                sh "echo $BRANCH_NAME"
                sh "mvn clean compile"
            }
        }
        stage('deploy') { 
            steps {
                sh "mvn package"
            }
        } 
        stage('SonarQube analysis')  {
            steps {
                 withSonarQubeEnv('sonarqube-8.9.6') {
                   sh 'mvn sonar:sonar'
                 }
           }
        }       
         stage ('Build Docker image') {
            steps {                
                script {
                    dockerImage = docker.build("$registryName/$BRANCH_NAME:$BUILD_NUMBER","--build-arg BRANCH_NAME=$env.BRANCH_NAME .")
                }
            }
        }
        stage('Upload Image to ACR') {
            steps{   
                script {
                    if (env.BRANCH_NAME == 'feature') {
                        echo "image will not push into ACR"
                    } else {
                        docker.withRegistry( "http://${registryUrl}", registryCredential ) {
                        dockerImage.push()
                        }
                    } 
               }
           }
       }
       stage ('deploy') {
            agent {
               label "$server"
            }
            steps {                
                script {
                    if (env.BRANCH_NAME == 'feature') {
                        echo "image will not pull from ACR"
                    } else {
                    docker.withRegistry( "http://${registryUrl}", registryCredential ) {
                        image = docker.image("$registryName/$BRANCH_NAME:$BUILD_NUMBER")
                        image.pull()
                        }
                    }
                }
            }
        } 
    }
}
