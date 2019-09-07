pipeline {
    agent any
    stages {
        stage('CleanWS') {
            when { expression { !shouldSkipBuild() } }
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            when { expression { !shouldSkipBuild() } }
            steps {
                checkout scm

                shHide( 'git remote set-url origin https://${GHTOKEN}@github.com/CompulsiveCoder/docker-nginx-arm.git' )
                sh "git config --add remote.origin.fetch +refs/heads/master:refs/remotes/origin/master"
                sh "git fetch --no-tags"
                sh 'git checkout $BRANCH_NAME'
                sh 'git pull origin $BRANCH_NAME'
            }
        }
        stage('Build') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh build.sh'
            }
        }
        stage('Tag') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh tag.sh'
            }
        }
        stage('Login') {
            when { expression { !shouldSkipBuild() } }
            steps {
                shHide( 'sh login.sh ${DOCKERHUB_USERNAME} ${DOCKERHUB_PASSWORD}' )
            }
        }
        stage('Push') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh push.sh'
            }
        }
        stage('Graduate') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh graduate.sh'
            }
        }
    }
    post {
        success() {
          emailext (
              subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
              body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
              recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
        failure() {
          sh 'sh rollback.sh'
          emailext (
              subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
              body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
              recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
Boolean shouldSkipBuild() {
    return sh( script: 'sh check-ci-skip.sh', returnStatus: true )
}
def shHide(cmd) {
    sh('#!/bin/sh -e\n' + cmd)
}
