// Describes the build process in Groovy

currentBuild.result = "SUCCESS"
def err = null

try {
    node {
        checkout scm
        stage 'Build and Test'
        buildPublishImage(env.JOB_NAME)
    }
} catch (caughtError) {
    err = caughtError
    currentBuild.result = "FAILURE"
} finally {
    if (currentBuild.result != "SUCCESS") {
        // Send slack notifications for failed or unstable builds.
        // currentBuild.result must be non-null for this step to work.
        if ("${env.JOB_NAME}".contains("master"))
        {
            slackSend channel: '#vector', color: 'bad', message: ":cry: Build failed - ${env.JOB_NAME} ${env.BUILD_NUMBER} - ${env.BUILD_URL}"
        }
    }

    /* Must re-throw exception to propagate error */
    if (err) {
        throw err
    }
}

def buildPublishImage(jobName) {
    configFileProvider([configFile(fileId: '721b2539-35ba-4612-81b2-f73d39ca08ad', variable: 'DOCKER_CONFIG_JSON')]) {
        sh 'mkdir -p ~/.docker && cp $DOCKER_CONFIG_JSON ~/.docker/config.json'
        withCredentials([usernamePassword(credentialsId: '8daa33e8-c1cb-4e78-babd-2e1a06de1c90', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
            if ("${jobName}".contains("master")) {
                sh 'build/build && build/publish'
            } else {
                sh 'build/build'
            }
        }
    }
}
