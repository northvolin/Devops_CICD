#!/bin/bash

#Генерим ключ копируем и отправляем в ТГ бот



# Создаем путь

ssh ${SSH_USER}@${SSH_HOST} "mkdir -p ${REMOTE_PATH}"

# Копируем содержимое проекта

scp -r /s21_CICD/* ${SSH_USER}@${SSH_HOST}:${REMOTE_PATH}

#Создаем файли перемещаем его в дирректорию проекта

echo "stages:
  -build_cat
  -build_grep

build_cat:
  stage: build_cat
  script:
  - cd ~/cat
  - make
  artifacts:
    paths:
      - s21_cat
      expire_in: 30 days
build_grep
  stage: build_grep
  script:
    - cd ~/grep
    - make
    artifacts:
      paths:
        - s21_grep
      expire_in: 30 days" > gitlab-ci.yml

#  Перемещаем файл в корень проекта

scp gitlab-ci.yml ${SSH_USER}@${SSH_HOST}:${REMOTE_PATH}

ssh ${SSH_USER}@${SSH_HOST} "cd ${REMOTE_PATH} && git add gitlab-ci.yml && git commit -m 'ADD gitlab-ci.yml' && git push"