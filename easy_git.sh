#!/usr/bin/env sh
# shellcheck disable=SC2181
# install some useful plugins when git init

check() {
  # check git
  git_status=$(git status)
  if [ $? -ne 0 ]; then
    echo "$git_status"
    exit 0
  fi

  # check yarn
  _=$(yarn -v)
  if [ $? -ne 0 ]; then
    echo "Not found yarn installed"
    exit 0
  fi
}

run() {
  # commitizen
  yarn global add commitizen
  commitizen init cz-conventional-changelog --yarn --dev --exact --force

  # changelog
  yarn global add conventional-changelog-cli

  # check manual commit
  yarn add @commitlint/config-conventional @commitlint/cli --dev
  echo "module.exports = {extends: ['@commitlint/config-conventional']}" >commitlint.config.js

  # wrap git hook
  yarn add husky --dev
  printf '\nInsert the following into package.json:'
  printf '\n\033[00;32m
  "husky": {"hooks": {"commit-msg": "commitlint -E HUSKY_GIT_PARAMS"}}
  \033[0m\n'
}

main() {
  check
  run
}

main

