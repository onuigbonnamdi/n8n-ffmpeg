FROM docker.n8n.io/n8nio/n8n:latest-debian

USER root

# If the base image is Debian buster (EOL), switch apt sources to the Debian archive
RUN set -eux; \
  if grep -q "buster" /etc/apt/sources.list 2>/dev/null || ls /etc/apt/sources.list.d/* 2>/dev/null | xargs -r grep -q "buster"; then \
    sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list || true; \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list || true; \
    find /etc/apt/sources.list.d -type f -print -exec sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' {} \; -exec sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' {} \; || true; \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid; \
  fi; \
  apt-get update; \
  apt-get install -y --no-install-recommends ffmpeg; \
  rm -rf /var/lib/apt/lists/*

USER node
