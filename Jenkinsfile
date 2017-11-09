#!/usr/bin/env groovy

node {

  stage('Prune Docker') {
    sh 'docker system prune -f'
  }

  stage('Build Container') {
    def image = docker.build('autostructure/laravel:latest', '--no-cache --pull .')

    image.push()
  }
}
