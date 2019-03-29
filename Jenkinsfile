node{
    def app

    stage('Clone Git'){
        checkout scm
    }

    stage('Build Image'){
        app = docker.build("nusrath432/nginx")
    }

    stage('Push Image'){
        docker.withRegistry('https://index.docker.io/v1/','nusrath-dockerhub-cred'){
            //app.push("nusrath432/nginx:${env.GIT_COMMIT}")
            app.push("nusrath432/nginx")
            app.push("latest")
        }
    }

}
