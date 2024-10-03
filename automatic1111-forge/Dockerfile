FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu20.04 AS python3.10-base

ENV DEBIAN_FRONTEND noninteractive

#Add new user
RUN adduser aiuser
#Add new group
RUN groupadd aigroup
#Add group to user
RUN usermod -aG aigroup aiuser


RUN apt update && apt upgrade -y
#Install the dependencies:
RUN apt install wget git libgl1 libglib2.0-0 -y
#Install TMalloc
RUN apt install -y libgoogle-perftools-dev
#Install Python
RUN apt install software-properties-common -y
RUN add-apt-repository 'ppa:deadsnakes/ppa' -y
RUN apt update && apt upgrade -y
RUN apt-get update && apt-get install python3.10 python3.10-venv -y

USER aiuser
WORKDIR /home/aiuser/

RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git
VOLUME /home/aiuser/stable-diffusion-webuiforge
WORKDIR /home/aiuser/stable-diffusion-webui-forge
COPY ./webui-user.sh /home/aiuser/stable-diffusion-webui-forge/webui-user.sh

EXPOSE 7860

ENTRYPOINT [ "./webui.sh" ]