@Library('my-shared-library') _

pipeline {
    agent any

    environment {
        APP_NAME = 'vsh-docker-proj'
    }

    stages {
        stage('Build & scan') {
            parallel {
                stage('Build') {
                    steps {
                        echo "Building ${env.APP_NAME}..."
                        sh "docker build -t ${APP_NAME}:${BUILD_NUMBER} ."
                    }
                }
                stage('Scan') {
                    steps {
                        echo "Scanning ${env.APP_NAME} for vulnerabilities..."
                        // Scan steps here (e.g. Trivy) — placeholder for now
                    }
                }                
            }
        }

        stage('Test') {
            steps {
                runTest()
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying ${env.APP_NAME} to Docker Hub..."
                withCredentials([usernamePassword(
                    credentialsId: 'vshalom-dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag $APP_NAME:$BUILD_NUMBER $DOCKER_USER/$APP_NAME:$BUILD_NUMBER
                        docker push $DOCKER_USER/$APP_NAME:$BUILD_NUMBER
                    '''
                }
            }
        }
    }
}
