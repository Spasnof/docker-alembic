# docker-alambic
Simple project structure for using alambic over git.

## requirements
- docker
- git

## how to use
- go to a feature branch.
- run `docker build -t <tagname> .` on this directory
- run `docker run <tagname>> revision -m "<revision description>"` to create a new revision `.py` file.
- commit the changes you wish.
- run and do something.

# TODO
- have only the versions be the mounted item.
