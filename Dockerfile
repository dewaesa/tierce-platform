#############################################################################
# Dockerizing tierce platform: Dockerfile for building tierce platform images
# Based on fedora:latest
#############################################################################
FROM fedora:latest

MAINTAINER Samuel Dewaele <samuel.dewaele@iteolia.com>

# installs glassfish

# MongoDB following the instructions from:
# http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/