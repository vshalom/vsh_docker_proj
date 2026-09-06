def appname = "vsh_docker_proj"
def repo = "vshalom"
def appimage = "${repo}/${appname}"
def apptag = "${env.BUILD_NUMBER}"
def dockerImage

podTemplate(containers: [
      containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent', ttyEnabled: true),
      containerTemplate(name: 'docker', image: 'docker:cli', command: 'cat', ttyEnabled: true),
      containerTemplate(name: 'trivy', image: 'aquasec/trivy:latest', command: 'cat', ttyEnabled: true),
      containerTemplate(name: 'helm', image: 'alpine/helm:latest', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
      hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ])
  {
    node(POD_LABEL) {
        stage('checkout') {
            container('jnlp') {
                sh '/usr/bin/git config --global http.sslVerify false'
                checkout scm
            }
        } // end checkout

        stage('Build & Scan FS') {
            parallel(
                'build': {
                    container('docker') {
                        echo "Building docker image..."
                        script {
                            dockerImage = docker.build("${appimage}:${apptag}")
                        }
                    }
                },
                'scan-fs': {
                    container('trivy') {
                        echo "Scanning source/filesystem with Trivy..."
                        sh "trivy fs ."
                    }
                }
            )
        } // end Build & Scan FS

        stage('push') {
            container('docker') {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'vshalom-dockerhub') {
                        dockerImage.push()
                    }
                }
            }
        } // end push

        stage('scan image') {
            container('trivy') {
                echo "Scanning pushed image ${appimage}:${apptag} with Trivy..."
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL --ignore-unfixed ${appimage}:${apptag}"
            }
        } // end scan image

        stage('Deploy') {
            container('helm') {
                echo "Rendering Helm chart to YAML manifest..."
                sh "helm template ${appname} ./chart > ${appname}.yaml"
                sh "cat ${appname}.yaml"
            }
        } // end Deploy
    }
}
