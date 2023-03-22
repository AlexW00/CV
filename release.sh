#! /bin/bash
TAG=$1

# check if tag is set
if [ -z "$TAG" ]; then
    echo "No release tag specified"
    exit 1
fi

# check if tag exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "Tag $TAG already exists"
    exit 1
fi

# check if tag is valid
if ! [[ $TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid tag $TAG"
    exit 1
fi

git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"