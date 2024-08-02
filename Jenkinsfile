pipeline {
  agent any
  stages {
    stage('Build and install Contrast Assess Agent') {
      steps {
        sh '''
        docker build -t nodegoat .
        '''
      }
    }
    stage('Run the built image') {
      steps {
        sh '''
        docker run -d -p 4000:4000 nodegoat
        '''
      }
    }
    stage('Scan image using Trivy') {
      steps {
        sh '''
        trivy image --no-progress --severity HIGH,CRITICAL nodegoat
        '''
      }
    }
  }
}
