// Describes the build process in Groovy

currentBuild.result = "SUCCESS"
def err = null

try {
	node{
	  stage 'Build and Test'
	  //slackSend channel: '#tlp-sandwich', color: 'good', message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} - ${env.BUILD_URL}"
	  checkout scm

          // copy docker config file to slave
          configFileProvider([configFile(fileId: '721b2539-35ba-4612-81b2-f73d39ca08ad', variable: 'DOCKER_CONFIG_JSON')]) {
            sh 'mkdir -p ~/.docker && cp $DOCKER_CONFIG_JSON ~/.docker/config.json'

            if ("${env.JOB_NAME}".contains("master"))
            {
              // AMorton, push images to docker hub if building master, see TS-198
              sh 'build/build && build/publish'
            }
            else
            {
              sh 'build/build'
            }

          }

          slackSend channel: '#tlp-sandwich-jenkins', color: 'good', message: ":smile: Build successful - ${env.JOB_NAME} ${env.BUILD_NUMBER} - ${env.BUILD_URL}"
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
          slackSend channel: '#tlp-sandwich', color: 'bad', message: ":cry: Build failed - ${env.JOB_NAME} ${env.BUILD_NUMBER} - ${env.BUILD_URL}"
        }
        slackSend channel: '#tlp-sandwich-jenkins', color: 'bad', message: ":cry: Build failed - ${env.JOB_NAME} ${env.BUILD_NUMBER} - ${env.BUILD_URL}"
    }

    /* Must re-throw exception to propagate error */
    if (err) {
        throw err
    }
}
