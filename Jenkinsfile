#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def dummy
goNode{
  def organisation = 'fabric8io'
  def project = 'go-pipeline-test-project'
  def buildPath = "/home/jenkins/go/src/github.com/${organisation}/${project}"

  sh "mkdir -p ${buildPath}"

  dir(buildPath) {
      git 'https://github.com/fabric8io/go-pipeline-test-project.git'

      sh "git config user.email fabric8-admin@googlegroups.com"
      sh "git config user.name fabric8-release"
      sh "git remote set-url origin git@github.com:${organisation}/${project}.git"
  }

  container(name: 'go') {

    stage ('build binary'){
      sh 'chmod 600 /root/.ssh-git/ssh-key'
      sh 'chmod 600 /root/.ssh-git/ssh-key.pub'
      sh 'chmod 700 /root/.ssh-git'
      
      sh "cd ${buildPath}; gobump -f version/VERSION patch"
      sh "cd ${buildPath}; git commit -am 'Version bump'"

      sh "cd ${buildPath} && git push origin master"
      sh "echo \$GITHUB_ACCESS_TOKEN"
      def flow = new io.fabric8.Fabric8Commands()
      def token = flow.getGitHubToken()
      input id: 'Proceed', message: "continue"
      sh "cd ${buildPath}; export GITHUB_ACCESS_TOKEN=${token}; make -e BRANCH=master release"
    }
  }

  container(name: 'docker') {
    def imageName = "docker.io/${organisation}/${project}:latest"
      stage ('build image'){
        sh "docker build -t ${imageName} ."
      }

      stage ('push image'){
        sh 'pwd'
        sh 'cd ~ && pwd'
        sh 'ls -al ~/.docker'
        sh "docker push ${imageName}"
      }
    }
  }