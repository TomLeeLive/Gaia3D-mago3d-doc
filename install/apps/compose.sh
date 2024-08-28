#!/usr/bin/env bash

# Print the usage
print_usage() {
  cat <<EOF
Usage: $0 [options] command [command args]
Options:
  --env-file <path>   : Specify an environment file. (default: .env-compose)
  -h, --help          : Print this message.

Commands:
  config              : Outputs the final config file, after doing merges and interpolations.
  build               : Build or rebuild services.
  push                : Push service images.
  up                  : Create and start containers.
  down                : Stop and remove containers.
  ps                  : List containers.
  logs                : View output from containers.

Examples:
  $0 up -d
  $0 --env-file .env up -d --build
EOF
}

# Print the error message
print_error() {
  echo -e "\033[31m$1\033[0m"
}

# Set the default env-file
ENV_FILE=.env.compose

# Parse the command line options
while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    print_usage
    exit 0
    ;;
  --env-file)
    if [ $# -ge 2 ]; then
      ENV_FILE="$2"
      shift 2
    else
      print_error "--env-file value is required"
      print_usage
      exit 1
    fi
    ;;
  build | push | config | up | down | ps | logs)
    command="$1"
    shift
    ;;
  *)
    break
    ;;
  esac
done

# Check the command
if [ -z "$command" ]; then
  print_error "command is required"
  print_usage
  exit 1
fi

# Check the env-file
if [ ! -f "${ENV_FILE}" ]; then
  print_error "File ${ENV_FILE} not found"
  print_usage
  exit 1
fi

# Run the command
case $command in
build)
  BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
  PROJECT_ROOT=${BASE_DIR}/../..
  (cd "${PROJECT_ROOT}" && echo ./gradlew "$@" jibDockerBuild)
  ;;

push)
  BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
  PROJECT_ROOT=${BASE_DIR}/../..
  (cd "${PROJECT_ROOT}" && ./gradlew "$@" jib)
  ;;

config | up | down | ps | logs)
  docker compose --env-file "${ENV_FILE}" -f docker-compose.base.yml -f docker-compose.compose.yml "$command" "$@"
  ;;
*)
  print_error "Unknown command: $command"
  print_usage
  exit 1
  ;;
esac
