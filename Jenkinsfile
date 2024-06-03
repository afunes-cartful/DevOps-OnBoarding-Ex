node {
    // Define environment variables in "Init" stage 
    stage('Init') {
        env.env_name = params.env_name
        env.HOST = "http://api-env.cartfulsolutions.com"
        env.OK_STATUS_CODE = "200"
        env.SRC_PATH = "Template/get_status_template.j2"
        env.DEST_PATH = "../output/get_status.sh"
        env.ANSIBLE_TEMP = "./Ansible/template.yml"
    }
    // Validate env_name in "parameters" stage
    stage('Parameters') {
        if (!env.env_name.matches(/.*(ing|dev).*/)) {
            error("Invalid env_name: ${env.env_name}. It must contain 'ing' or 'dev'.")
        }
    }
    // Build and execute the cURL script in "get_status" stage
    stage('Get Status') {
        sh  """
            echo ${WORKSPACE}
            python3 --version
            which ansible
        """
        ansiblePlaybook(
                    playbook: "${env.ANSIBLE_TEMP}",
                    extras: "target=localhost src=${env.SRC_PATH} dest=${env.DEST_PATH} API_HOST=${env.HOST} ENV_NAME=${env.env_name}",
                    colorized: true
                )
        def status = sh(script: '. output/get_status.sh', returnStdout: true).trim()
        // Store the status in the environment for later use
        env.HTTP_STATUS = status
    }
    // Validate the status code in "validate_status" stage
    stage('Validate Status') {
        if (env.HTTP_STATUS != env.OK_STATUS_CODE) {
            error("Status code is not ${env.OK_STATUS_CODE}: ${env.HTTP_STATUS}")
        }
    }
    // Notification stage
    stage('Notification') {
        echo "The env_name ${env.env_name} was evaluated and returned status ${env.status}."
    }
}
