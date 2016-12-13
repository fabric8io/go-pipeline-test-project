#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def dummy
goNode{
  dockerNode{  
    def organisation = 'fabric8io'
    def project = 'go-pipeline-test-project'
    def buildPath = "/home/jenkins/go/src/github.com/${organisation}/${project}"

    sh "mkdir -p ${buildPath}"

    dir(buildPath) {
        git 'https://github.com/fabric8io/go-pipeline-test-project.git'

        sh "git config user.email fabric8-admin@googlegroups.com"
        sh "git config user.name fabric8-release"
        sh "git remote set-url origin git@github.com:${organisation}/${project}.git"
    

        container(name: 'go') {

        stage ('build binary'){
          sh 'chmod 600 /root/.ssh-git/ssh-key'
          sh 'chmod 600 /root/.ssh-git/ssh-key.pub'
          sh 'chmod 700 /root/.ssh-git'
          
          sh "gobump -f version/VERSION patch"
          sh "git commit -am 'Version bump'"

          sh "git push origin master"
          
          def token = new io.fabric8.Fabric8Commands().getGitHubToken()
          sh "export GITHUB_ACCESS_TOKEN=${token}; make -e BRANCH=master release"
        }
      }

      container(name: 'docker') {
        def imageName = "docker.io/${organisation}/${project}:latest"
        //input id: 'Proceed', message: "continue"
        stage ('build image'){
          sh "docker build -t ${imageName} ."
        }

        stage ('push image'){
          sh 'echo $DOCKER_CONFIG'
          sh 'env'
          
          sh 'ls -al $DOCKER_CONFIG'
          sh "docker push ${imageName}"
        }
      }
    }
  }
}


  