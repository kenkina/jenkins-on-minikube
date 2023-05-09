<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h1 align="center">Jenkins on Minikube</h1>
  <p align="center">
    Jenkins deployed on Minikube for testing purposes
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#methodology">Methodology</a></li>        
        <li><a href="#roadmap">Roadmap</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#security-considerations">Security considerations</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#uninstallation">Uninstallation</a></li>
      </ul>
    </li>
    <li><a href="#license">License</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<p align="center">
  <img src="docs/diagram.drawio.svg" alt="docs/diagram.drawio.svg"/>
</p>



<!-- FEATURES -->
### Features

1. Jenkins installed on Minikube with Helm (JCasC for configuration)
    - Docker image: [jenkins-on-minikube](https://hub.docker.com/r/kenkina/jenkins-on-minikube)
2. Jenkins agent for Maven 3 (Java 17)
    - Docker image: [jenkins-inbound-maven-agent](https://hub.docker.com/r/kenkina/jenkins-inbound-maven-agent)
3. Common tools containerized (kaniko + crane)
    - Docker image: [jenkins-container-tools](https://hub.docker.com/r/kenkina/jenkins-container-tools)
4. Example of backend deployment on Minikube
    - Source code: [spring-hateoas-backend-java8](https://github.com/kenkina/spring-hateoas-backend-java8)
4. Ingress controller to expose Jenkins and examples



<!-- METHODOLOGY -->
### Methodology

This project was made following these steps:

1. Install Jenkins with default chart values
2. Get the default chart values (`helm/values.yaml`)
3. Check if all is working (`pipelines/*`)
4. Update plugins
5. Check if all is working (`pipelines/*`)
6. Get updated plugins versions
7. Modify Dockerfile with updated plugins versions
8. Upload new Docker image (`image/Dockefile`)
9. Update chart values (`helm/values.custom.yaml`)

Commands are listed in (<a href="docs/commands.md">`docs/commands.md`</a>)



<!-- ROADMAP -->
### Roadmap

- [x] (docs) Write "Methodology"
- [x] (docs) Write "Security considerations"
- [ ] (scripts) Set parameters in a different sh file (`scripts/_params.sh`)
- [ ] Configure backup lifecycle
- [ ] Update Jenkins (Jenkins chart 4.3.23)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started



<!-- PREREQUISITES -->
### Prerequisites

* Ubuntu 22.04
* Docker 23.0.4
* Docker Hub account (Read `Security consideration #1`)
* Kubectl v1.27.1
* Minikube v1.30.1
* Helm v3.11.3
* Jenkins chart 4.3.20 (Jenkins 2.387.2)
* Github account (Jenkins uses SSH to connect to Github. Read `Security considerations #2 and #3`)



<!-- SECURITY CONSIDERATIONS -->
### Security considerations

* #1. The script `scripts/_init.sh` requires a `$HOME/.docker/config.json` file to connect Jenkins to Docker hub. You can create this file with `docker login`. This consideration is based on https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry

* #2. Public SSH key fingerprints are used to validate a connection to a remote server. In this project, Jenkins uses [GitHub's SSH key fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints). They are configured as `approvedHostKeys` in `helm/values.security.yaml`. Those values could change in the future.

* #3. The script `scripts/_init.sh` requires a SSH key to connect Jenkins to Github. If there is a SSH key in path `GITHUB_SSH_KEY_FILE`, the script will ask to use it. Else, a new SSH key will be created and then the public key must be registered on your Github account. When you uninstall this project, you should consider to remove the SSH key from local and your Github account. This consideration is based on https://docs.github.com/en/authentication/connecting-to-github-with-ssh



<!-- INSTALLATION -->
### Installation

1. Clone the repo
    ```sh
    git clone https://github.com/kenkina/jenkins-on-minikube.git
    ```
2. (Optional) Change parameters in `scripts/_init.sh`

3. Execute `scripts/_init.sh`
   ```sh
   sh scripts/_init.sh
   ```



<!-- UNINSTALLATION -->
### Uninstallation

1. Execute `scripts/_wipe.sh`
   ```sh
   sh scripts/_wipe.sh
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See <a href="LICENSE.txt">`LICENSE.txt`</a> for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>






<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/kenkina/jenkins-on-minikube.svg?style=for-the-badge
[contributors-url]: https://github.com/kenkina/jenkins-on-minikube/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/kenkina/jenkins-on-minikube.svg?style=for-the-badge
[forks-url]: https://github.com/kenkina/jenkins-on-minikube/network/members
[stars-shield]: https://img.shields.io/github/stars/kenkina/jenkins-on-minikube.svg?style=for-the-badge
[stars-url]: https://github.com/kenkina/jenkins-on-minikube/stargazers
[issues-shield]: https://img.shields.io/github/issues/kenkina/jenkins-on-minikube.svg?style=for-the-badge
[issues-url]: https://github.com/kenkina/jenkins-on-minikube/issues
[license-shield]: https://img.shields.io/github/license/kenkina/jenkins-on-minikube.svg?style=for-the-badge
[license-url]: https://github.com/kenkina/jenkins-on-minikube/blob/master/LICENSE.txt
[linkedin-url]: https://hub.docker.com/r/kenkina/jenkins-on-minikube