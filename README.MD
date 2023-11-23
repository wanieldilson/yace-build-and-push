# Terraform build and push example for YACE

## Summary
A little terraform snippet using a null resource triggered by a version change.  So whenever the version is update in the repo, a new image will be built and pushed to ECR.  This is for [YACE](https://github.com/nerdswords/yet-another-cloudwatch-exporter) but can be adapted for anything.