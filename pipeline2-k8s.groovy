pipeline {
    agent { label 'k8s'}

    stages {
        stage ('cloning Git-repo') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/Ravivarman16/TASK-PROJECT.git'
            }
        }
        stage ('production by k8s') {
            steps {
                sh 'kubectl apply -f k8s.yml'
            }
        }
    }
}
