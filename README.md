#Kubernetes Proxy

**I've stopped updating this project for now as I ran into too many errors (mainly getpwnam). I'm leaving this repo here for other to see**

This is an nginx reverse proxy together with confd. I'm out of creative names, so I'm just calling it what it is.

The reason I created a new container instead of using one of the many exisiting ones is that we plan on integrating [let's encrypt](https://letsencrypt.org) once it launches. Also, I think all the official images are bloated.

