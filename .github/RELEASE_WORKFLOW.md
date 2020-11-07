# Release Workflow

This document describes the workflow to apply for releasing.

## Steps

1. Prepare

    * Code is ready, documented, tested for versioning.
    * Update `CHANGELOG.md` according to the release version, release date and change details, and the [[Changelog Template](#changelog-template)] below.
    * Delete empty sections in `CHANGELOG.md`.
    * Review `README.md` by removing roadmap-related messages ("Not Yet Implemented", "Roadmap vX.Y.Z", etc.) and other updates if needed.
    * Commit `CHANGELOG.md`.
    * Commit `README.md`.
    * Update [[Wiki/Build-Details](https://github.com/swaf-project/swaf-docker/wiki/Build-Details)] with last used versions.

2. Tag & Release

    * ALTERNATIVE 1 - Tag locally then make the GitHub release

      * `git checkout master` **#** Be sure to be on master branch
      * `git tag -a v<X.Y.Z> -m "Release version <X.Y.Z>"` **#** Tag master HEAD
      * `git push origin master --tags` **#** Push master branch with tags to the remote origin
      * Create the release on GitHub according to the [[GitHub Release Template](#github-release-template)] below with the existing tag.

    * ALTERNATIVE 2 - Create tag at the GitHub release creation step

      * Create the release on GitHub according to the [[GitHub Release Template](#github-release-template)] below especially for TAG and TITLE.
      * `git pull origin` **#** To locally pull the tag

## Changelog Template

```text
# Changelog

## Version <X.Y.Z> (<YYYY-MM-DD>)

Breaking Changes:

* <TEXT>

New Features:

* <TEXT>

Improvements:

* <TEXT>

Security Issues:

* <TEXT>

Bugfixes:

* <TEXT>
```

## GitHub Release Template

* TAG (_Existing or to create_):

  * v<X.Y.Z>

* TITLE (_The same as tag_):

  * v<X.Y.Z>

* BODY TEMPLATE:

```text
<TEXT/COMMENT>

Please get the docker image on [[Docker Hub](https://hub.docker.com/r/swafproject/swaf)]: `docker pull swafproject/swaf`

<RELEASE_NOTE_BODY_COPIED_FROM_CHANGELOG>
```
