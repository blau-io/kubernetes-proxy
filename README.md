#Kubernetes Proxy

[![wercker status](https://app.wercker.com/status/1bb3baca07e01523a8fa967f93355e60/s "wercker status")](https://app.wercker.com/project/bykey/1bb3baca07e01523a8fa967f93355e60)

This is an nginx reverse proxy together with confd. I'm out of creative names, so I'm just calling it what it is.

The reason we are creating a new container instead of using one of the many exisiting ones is that we plan on integrating (let's encrypt)[https://letsencrypt.org] once it launches.

**This project is still under heavy development, it is not recommended to use it in production.**
