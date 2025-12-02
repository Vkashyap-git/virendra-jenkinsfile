pipeline {
    agent any

    stages {

        stage('Git Checkout') {
            steps {
                echo "Cloning repository..."
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/Vkashyap-git/virendra-jenkinsfile.git']]
                ])
            }
        }

        stage('SSH into EC2') {
            steps {
                echo "Connecting to EC2 (test only)..."
                sshagent(['virendra-jenkins']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@16.176.176.106 "echo Connected Successfully"
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo "Deploying app to EC2..."

                sshagent(['virendra-jenkins']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no deploy.yml ubuntu@16.176.176.106:/home/ubuntu/

                    ssh -o StrictHostKeyChecking=no ubuntu@16.176.176.106 '
                        sudo mkdir -p /opt/demo-app &&
                        sudo cp /home/ubuntu/deploy.yml /opt/demo-app/
                    '
                    '''
                }
            }
        }

        stage('Validate Deployment') {
            steps {
                sshagent(['virendra-jenkins']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@16.176.176.106 "
                        echo 'Deployment files:'
                        ls -l /opt/demo-app/
                    "
                    '''
                }
            }
        }

        stage('Success Message') {
            steps {
                echo "🎉 Deployment Successful!"
            }
        }
    }
}
