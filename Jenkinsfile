#!/usr/bin/env groovy

node {
  checkout scm

  def server = Artifactory.server('artifactory')

  def artifactoryMaven = Artifactory.newMavenBuild()

  artifactoryMaven.tool = 'M3' // Tool name from Jenkins configuration
  artifactoryMaven.deployer releaseRepo:'libs-release-local', snapshotRepo:'libs-snapshot-local', server: server
  artifactoryMaven.resolver releaseRepo:'libs-release', snapshotRepo:'libs-snapshot', server: server

  def buildInfo = Artifactory.newBuildInfo()


  stage('Package') {
    // Run Maven:
    def buildInfoInstall = artifactoryMaven.run pom: 'pom.xml', goals: 'clean package checkstyle:checkstyle findbugs:findbugs cobertura:cobertura pmd:pmd install'

    buildInfo.append(buildInfoInstall)

    // Publish the build-info to Artifactory:
    server.publishBuildInfo buildInfo
  }

  stage('Prune Docker') {
    sh 'docker system prune -f'
  }

  stage('Build Container') {
    def image = docker.build('repo/app:canary', '--no-cache --pull .')

    image.push()
  }
}
