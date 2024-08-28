#!/bin/bash

for tarfile in *.tar; do
    if [ -f "$tarfile" ]; then
        echo "Loading Docker image from $tarfile..."
        docker load -i "$tarfile"
        echo "Loaded $tarfile"
    else
        echo "No .tar files found in $IMAGE_DIR"
    fi
done