# Testing
Unit testing the SpinW master branch using Docker

Run tests with:

`docker-compose build --no-cache test_version && docker-compose up test_version`

Where `test_version` is `v2017b_ub`, `v2015b_ub`, `v2014b_ub` in order to test on an Ubuntu 16.04 (LTS) system or `v2017b_cs`, `v2015b_cs`, `v2014b_cs` to test on a CentOS 7 system.

