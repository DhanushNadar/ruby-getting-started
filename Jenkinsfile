pipeline {
    agent any
    
    environment {
        APP_VERSION = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('CloneCode') {
            steps {
                git branch: 'main', url: 'https://github.com/DhanushNadar/ruby-getting-started.git'
            }
        }
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')])
                {
                sh 'docker build . -t ${dockerHubUser}/ruby-app:${APP_VERSION}'
                sh "sed -i 's|image: ${dockerHubUser}/ruby-app:.*|image: ${dockerHubUser}/ruby-app:${APP_VERSION}|' docker-compose.yml"
                }
            }
        }
        stage('Test'){
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')])
                {
                sh 'trivy image ${dockerHubUser}/ruby-app:${APP_VERSION} > trivyimage.txt'
                }
            }
        }
        stage('Push to DockerHub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')])
                {
                sh 'docker login -u ${dockerHubUser} -p {dockerHubPass}'
                sh 'docker push ${dockerHubUser}/ruby-app:${APP_VERSION}'
                }
            }
        }
        stage('Deploy by pushing the code to Github') {
            steps {
                sh '''
                git add .
                git commit -m "updated the latest version ${APP_VERSION} "
                git push https://${GITHUB_TOKEN}@github.com/DhanushNadar/ruby-getting-started HEAD:main
                '''
            }
        }
    }
}
