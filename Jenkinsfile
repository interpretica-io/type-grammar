pipeline {
  agent {
    dockerfile {
       filename 'Dockerfile_ubuntu_2004'
       dir 'tools/build-env'
    }
  }
  stages {
    stage('Test grammar') {
      steps {
        sh 'mkdir -p build && ./tools/test.sh junit build/test.xml'
      }
    }
  }
  post {
        always {
            junit 'build/test.xml'
        }
  }
}