#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def dummy
goNode{
  def organisation = 'fabric8io'
  def project = 'go-pipeline-test-project'
  def buildPath = "/go/src/github.com/${organisation}/${project}"

  sh "mkdir -p /go/src/github.com/${organisation}/${project}"

  dir("/go/src/github.com/${organisation}/${project}") {
      checkout scm
      sh 'pwd'
      sh 'ls -al'

      container(name: 'go') {
          sh 'pwd'
          sh 'ls -al'
          stage ('build binary'){
            sh 'chmod 600 /root/.ssh-git/ssh-key'
            sh 'chmod 600 /root/.ssh-git/ssh-key.pub'
            sh 'chmod 700 /root/.ssh-git'

            sh "git remote set-url origin git@github.com:${config.project}.git"
            
            sh 'gobump -f version/VERSION patch'
            sh "git commit -am 'Version bump'"
            sh 'git push -u origin master'
            sh "make release"
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
}