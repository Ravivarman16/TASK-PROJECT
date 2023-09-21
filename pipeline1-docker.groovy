pipeline {
    agent { label 'docker' }

    stages {
        stage('Git cloning') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Ravivarman16/TASK-PROJECT.git'
            }
        }

        stage ('Building a dockerimage') {
            steps {
                sh 'docker rm -f $(docker ps -aq)'
                sh 'docker build -t ravivarman46/image .'
                sh 'docker run -d --name container1 -p 8080:80 ravivarman46/image'
                sh 'docker push ravivarman46/image'
            }
        }
    }
}
