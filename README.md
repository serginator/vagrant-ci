vagrant-ci
=============

Configuration for a machine with:

* git
* java
* jenkins
* sonar
* nodejs

## Usage

```
git clone git@github.com:serginator/vagrant-ci.git
cd vagrant-ci
vagrant up
```

After the loading it will redirect some ports on your machine and you'll be able to enter to Jenkins through [localhost:8080](http://localhost:8080) and Sonar through [localhost:9000](http://localhost:9000).

## TODO

* Add some tweaks
* Add database for sonar (MySQL or PostgreSQL)
* Add a clean nginx server
* Add logrotates

