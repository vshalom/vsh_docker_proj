pipeline {
    agent any

    environment {
        APP_NAME = 'vsh-docker-proj'
    }

    stages {
        stage('Build') {
            steps {
                echo "Building ${env.APP_NAME}..."
                sh "docker build -t ${APP_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
                // Test steps here
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
