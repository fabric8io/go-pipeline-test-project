#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def dummy
goNode{
  dockerNode{  
    def githubOrganisation = 'fabric8io'
    def dockerOrganisation = 'fabric8'
    def project = 'go-pipeline-test-project'
    def buildPath = "/home/jenkins/go/src/github.com/${githubOrganisation}/${project}"
    
    sh "mkdir -p ${buildPath}"

    dir(buildPath) {
      git "https://github.com/${githubOrganisation}/${project}.git"

      sh "git config user.email fabric8-admin@googlegroups.com"
      sh "git config user.name fabric8-release"
      sh "git remote set-url origin git@github.com:${githubOrganisation}/${project}.git"
      def version
      container(name: 'go') {
        stage ('build binary'){
          sh 'chmod 600 /root/.ssh-git/ssh-key'
          sh 'chmod 600 /root/.ssh-git/ssh-key.pub'
          sh 'chmod 700 /root/.ssh-git'
          
          if (!fileExists('version/VERSION')){
            error 'no version/VERSION found'
          }

          sh "gobump -f version/VERSION patch"
          sh "git commit -am 'Version bump'"
          version = readFile('version/VERSION').trim()

          sh "git push origin master"
            
          def token = new io.fabric8.Fabric8Commands().getGitHubToken()
          sh "export GITHUB_ACCESS_TOKEN=${token}; make -e BRANCH=master release"
        }
      }

      container(name: 'docker') {
        def imageName = "docker.io/${dockerOrganisation}/${project}"

        stage ('build image'){
          sh "docker build -t ${imageName}:latest ."
        }

        stage ('push latest images'){
          sh "docker push ${imageName}:latest"
          sh "docker tag ${imageName}:latest ${imageName}:${version}"
          sh "docker push ${imageName}:${version}"
        }
      }
    }
  }
}


  