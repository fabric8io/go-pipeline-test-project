#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def dummy
goNode{
  def organisation = 'fabric8io'
  def project = 'go-pipeline-test-project'
  container(name: 'go') {
    stage ('build binary'){
      sh "go get github.com/${organisation}/${project}"
      sh "cd /go/src/github.com/${organisation}/${project}; make"

      sh "cp -R /go/src/github.com/${organisation}/${project}/out ."
    }
  }

  container(name: 'docker') {
    def imageName = 'docker.io/${organisation}/${project}:latest'
    stage ('build image'){
      sh "cd /go/src/github.com/${organisation}/${project}; docker build -t ${imageName} ."
    }

    stage ('push image'){
      sh 'pwd'
      sh 'cd ~ && pwd'
      sh 'ls -al ~/.docker'
      sh "cd /go/src/github.com/${organisation}/${project}; docker push ${imageName}"
    }
  }
}