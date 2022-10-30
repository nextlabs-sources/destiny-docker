#!groovy

pipeline {

  agent any

  parameters {
    string(name: 'DESTINY_BUILD_ARTIFACTS_ZIP_FILE', defaultValue: '${SDRIVE}/build/release_artifacts/Destiny/9.0.0.0/11/destiny-9.0.0.0-11-201909062037-build.zip', description: 'Required, Path to destiny build zip')
    string(name: 'DESTINY_XLIB_ARTIFACTS_ZIP_FILE', defaultValue: '${SDRIVE}/build/release_artifacts/Destiny/9.0.0.0/11/destiny-9.0.0.0-11-201909062037-xlib.zip', description: 'Required, Path to destiny xlib zip')
    string(name: 'OAUTH2JWTSECRET_PLUGIN_ZIP', defaultValue: '${SDRIVE}/build/release_candidate/plugins/Oauth2JWTSecretPlugin/9.0.0/17/Oauth2JWTSecret-Plugin-9.0.0-17-201909020022.zip', description: 'Required, Path to oauth2 jwt plugin build zip')
    string(name: 'CC_LINUX_CHEF_INSTALLER_ZIP_FILE', defaultValue: '${SDRIVE}/build/release_candidate/Platform/9.0.0.0/11/ControlCenter-Linux-chef-SaaS-9.0.0.0-11.zip', description: 'Required, Path to copy Tomcat and Jre')
    string(name: 'JPC_ZIP_FILE', defaultValue: '${SDRIVE}/build/release_candidate/PolicyControllerJava/9.0.0.0/11/PolicyControllerJava-9.0.0.0-11.zip', description: 'Required, use tomcat from base docker image itself')

  
    string(name: 'DestinyDockerBuildJob', defaultValue: '', description: 'Optional, Docker build job name on same jenkins to be triggered after build')
    string(name: 'docker_image_tag', defaultValue: 'latest', description: 'Optional, the docker tag parameter to pass to DestinyDockerBuildJob')
  }
  
  stages {
    
    stage('Cleanup') {
      steps {
        cleanWs()
        checkout scm
      }
    }
    
    stage('Prepare') {
        steps {
          echo "DESTINY_BUILD_ARTIFACTS_ZIP_FILE is ${params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE}"
          echo "DESTINY_XLIB_ARTIFACTS_ZIP_FILE is ${params.DESTINY_XLIB_ARTIFACTS_ZIP_FILE}"
          echo "OAUTH2JWTSECRET_PLUGIN_ZIP is ${params.OAUTH2JWTSECRET_PLUGIN_ZIP}"
          echo "workspace: ${env.WORKSPACE}"
        }
    }

    stage('UnpackDestinyArtifacts') {
      steps {
        parallel(
          "unzip_destiny_apps": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "run/server/apps/*.war"
          },
          "unzip_destiny_certificates": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "enrollment.cer"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "keymanagement.cer"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "policyAuthor.cer"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "temp_agent.cer"
          },
          "unzip_destiny_configuration": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "run/server/configuration/*.xml"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "run/server/configuration/*.xsd"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "agentprofile.xml"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "commprofile.template.xml"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "mapping.xml"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "temp_agent-keystore.jks"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "run/server/certificates/temp_agent-keystore.jks"
          },
          "unzip_destiny_shared_lib": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "common-version.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "crypt.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "server-axis-security.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "nextlabs/tomcat/shared_lib/server-base.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "nextlabs/tomcat/shared_lib/server-base-internal.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "server-security.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "run/server/license/license.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "nextlabs/tomcat/shared_lib/nxl-filehandler.jar"
          },

          "uznip_destiny_xlib": {
            
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "nextlabs/tomcat/shared_lib/c3p0-0.9.5.2.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/xlib/jar", glob: "nextlabs/tomcat/shared_lib/c3p0-0.9.5.2.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/xlib/jar", glob: "nextlabs/tomcat/shared_lib/commons-logging-1.1.1.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/xlib/jar", glob: "nextlabs/tomcat/shared_lib/ojdbc8.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/xlib/jar", glob: "nextlabs/tomcat/shared_lib/postgresql-9.2-1002.jdbc4.jar"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/xlib/jar", glob: "nextlabs/tomcat/shared_lib/sqljdbc41.jar"
          },

          "unzip_destiny_license": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/run/server", glob: "license.dat"
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/run/server", glob: "license.jar"
          },
          "unzip_destiny_tools": {
            unzip zipFile: params.DESTINY_BUILD_ARTIFACTS_ZIP_FILE, dir: "${env.WORKSPACE}/destiny", glob: "**/tools/**"
           
          },
          "unzip_oauth2_jwt_plugin": {
            unzip zipFile: params.OAUTH2JWTSECRET_PLUGIN_ZIP, dir: "${env.WORKSPACE}/plugins/Oauth2JWTSecret-Plugin"
          },

          
          // copy 
           "unzip_cc_tomcat": {
            unzip zipFile: params.CC_LINUX_CHEF_INSTALLER_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/tomcat", glob: "**/tomcat/**"
          },
           "unzip_cc_jre": {
            unzip zipFile: params.CC_LINUX_CHEF_INSTALLER_ZIP_FILE, dir: "${env.WORKSPACE}/destiny/java", glob: "**/java/**"
          },
           "unzip_jpc": {
            unzip zipFile: params.JPC_ZIP_FILE, dir: "${env.WORKSPACE}/jpc", glob: "**"
          }

        )
      }
    }
    
    stage('OrganizeArtifacts') {
      steps {
        parallel(
          "apps": {
            fileOperations([
              fileCopyOperation(
                excludes: '**/rest-api.war',
                flattenFiles: true,
                includes: 'destiny/run/server/apps/*.war',
                targetLocation: 'destiny_artifacts/apps'
              )
            ])
          },
          "certificates": {
            fileOperations([
              fileCopyOperation(
                flattenFiles: true,
                includes: 'destiny/*.cer',
                targetLocation: 'destiny_artifacts/certificates'
              )
            ])
          },
          "configuration": {
            fileOperations([

              folderCopyOperation(
                sourceFolderPath: 'destiny/run/server/configuration',
                destinationFolderPath: 'destiny_artifacts/configuration'
              )
              
            ])
          },      
          "plugins": {
            dir('plugins/Oauth2JWTSecret-Plugin') {
              fileOperations([
                fileCopyOperation(
                  includes: '**/**',
                  targetLocation: "${env.WORKSPACE}/destiny_artifacts/plugins/Oauth2JWTSecret-Plugin"
                )
              ])
            }
          },
        
          "shared/license": {
            fileOperations([
              fileCopyOperation(
                flattenFiles: true,
                includes: 'destiny/run/server/license.dat',
                targetLocation: 'destiny_artifacts/shared/lib'
              ),
              fileCopyOperation(
                flattenFiles: true,
                includes: 'destiny/run/server/license/license.jar',
                targetLocation: 'destiny_artifacts/shared/lib'
              )
            ])
          },
          "Copy tools folder": {
            fileOperations([
            folderCopyOperation(
                sourceFolderPath: 'destiny/tools',
                destinationFolderPath: 'destiny_artifacts/tools'
              )
            ])
          },
           "customized_tomcat_and_java": {
           
              fileOperations([
                folderCopyOperation(
                  sourceFolderPath: 'destiny/tomcat/PolicyServer/dist/Policy_Server/server/tomcat',
                  destinationFolderPath: 'destiny_artifacts/tomcat'
                ),
                folderCopyOperation(
                  sourceFolderPath: 'destiny/java/PolicyServer/platform/ppc64_suse/java',
                  destinationFolderPath: 'destiny_artifacts/java'
                )
                
              ])

            }

        )
      }
    }

    stage('PostCleanup') {
      steps {
        dir('destiny') {
         // deleteDir()
        }
        dir('plugins') {
        //  deleteDir()
        }
      }
    }

    stage('TriggerDockerBuild') {
      when {
        // Only do this if DestinyDockerBuildJob is defined
        expression { "${params.DestinyDockerBuildJob}" != "" }
      }
      steps {

        echo "${params.DestinyDockerBuildJob}"

        build job: "${params.DestinyDockerBuildJob}", parameters: [
          string(name: 'destiny_artifacts', value: "${env.WORKSPACE}/destiny_artifacts"),
          string(name: 'docker_image_tag', value: params.docker_image_tag)
        ]
      }
    }
  }
}
