## Jenkins build "destiny_artifacts"

### Requirements

The jenkins server should have packer executable in PATH. Packer is the tool used to build the docker images, it's a standalone binary file. Download it from [Packer office website](https://www.packer.io/downloads.html).

Currently the build can only be done on a Linux Jenkins server. The jenkins server should have docker engine installed and the jenkins user should be allowed to call docker commands without `sudo` (this normally can be done by adding the jenkins user to docker group).

### Requirement

Jenkins server should have the pipeline related plugins installed. In addition, plugins list below should also be installed:

* Docker Pipeline
* Pipeline Utility Steps


### Parameters

* destiny_artifacts: (Required) The path to the destiny_artifacts folder on jenkins server.
* docker_image_tag: (Required) The tag to the images to be built.
* DOCKER_REGISTRY_URL: (Optional) The docker registry url to publish the images onto.
* DOCKER_REGISTRY_CREDENTIAL_ID: (Optional) The credential to the docker registry stored in the jenkins server.

## Jenkins build "destiny_artifacts"

The destiny_artifacts jenkinsfile is Jenkins pipeline file that builds a destiny_artifacts folder for the container build. It takes the destiny build artifacts zip path and oauth2 jwt plugin zip path as input and produces proper build artifacts to be used by container build.

### Requirement

Jenkins server should have the pipeline related plugins installed. In addition, plugins list below should also be installed:

* Pipeline Utility Steps
* Workspace Cleanup Plugin
* File Operations Plugin

### Parameters

* DESTINY_BUILD_ARTIFACTS_ZIP_FILE: (Required) Path to the destiny build zip.
* DESTINY_XLIB_ARTIFACTS_ZIP_FILE: (Required) Path to the destiny xlib zip.
* OAUTH2JWTSECRET_PLUGIN_ZIP:(Required) Path to the oauth2 zip.
* DestinyDockerBuildJob: (Optional) The docker build job in same jenkins server to trigger after this build is done.

