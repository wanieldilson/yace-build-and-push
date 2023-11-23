#!/bin/bash
set -euo pipefail

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <image_name> <image_version> <ecr_auth_token_proxy_endpoint> <ecr_auth_token_password>"
    exit 1
fi

# Set the image_name and image_version from command line arguments
image_name="$1"
image_version="$2"
ecr_auth_token_proxy_endpoint="$3"
ecr_auth_token_password="$4"

DOCKERFILE_COPY_CMD="COPY config.yml /tmp/config.yml"
GITHUB_REPO="https://github.com/nerdswords/yet-another-cloudwatch-exporter"
TAR_FILE="v${image_version}.tar.gz"
GITHUB_RELEASE_URL="${GITHUB_REPO}/archive/refs/tags/${TAR_FILE}"
EXPORTER_DIR="yet-another-cloudwatch-exporter-${image_version}"

docker login "${ecr_auth_token_proxy_endpoint}" -u AWS -p "${ecr_auth_token_password}"

wget "${GITHUB_RELEASE_URL}"
tar -xf "${TAR_FILE}"
rm "${TAR_FILE}"
cp "config.yml" "${EXPORTER_DIR}"
cd "${EXPORTER_DIR}"

echo "${DOCKERFILE_COPY_CMD}" >> Dockerfile
docker build -t "${image_name}:${image_version}" .
docker push "${image_name}:${image_version}"

cd ..
rm -rf "${EXPORTER_DIR}"
