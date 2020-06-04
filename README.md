## Docker Images for Spark

This respository contains the Dockerfile for different Spark versions. Each image consists of a script, `entrypoint.sh` that is responsibile for starting
the different components in Spark namely - master, worker and the history server.

### Objective

The main objective for all the images in this repository is to give developers and beginners to Spark, an easy to use single node Spark cluster for exploration and experimentation. These images must not be used for running spark containers in kubernetes, but can definitely be used as a reference for building spark docker image for kubernetes.
