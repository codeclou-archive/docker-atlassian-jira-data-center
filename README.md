# jiranode-8.3.0



### Since Jira 8.3.0 

Since Jira 8.3.0 we provide Jira "pre installed" since there is a problem
with the cluster.properties.


### Howto Create Home-Dir Zips and DB Dump

```
docker build . -t j830
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=jira -e POSTGRES_USER=jira postgres:9.4

docker run -i -t -p 8080:8080 j830 bash
```

Inside Docker

```
# Delete cluster.properties !!! Since Jira 8.3 setup gets stuck if cluster.properties exists prior to full setup!
rm /jira-home/cluster.properties
rm /jira-home/dbconfig.xml
/jira/atlassian-jira-software-latest-standalone/bin/catalina.sh run
```

Do full setup of Database and admin user, then shutdown with CTRL+C

 * http://localhost:8080
 * Use the host IP as Database Host and User/Pass/Db=jira

```
# HOME DIR
cd /jira-home
rm -rf ./plugins/.osgi-plugins/felix/felix-cache/*
tar cfjv ../jira-home-8.3.0.tar.bz2 *
# 29 MB
#
# SHARED HOME
cd /jira-shared-home/
tar cfjv ../jira-shared-home-8.3.0.tar.bz2 *
# 21 MB
```



Backup Database

```
pg_dump -d jira -h 192.168.178.11 -p 5432  -U jira --file=/tmp/jira-8.3.0-postgresql.dump
```

Remove all the cluter from top of the dump, so that only plain CREATE TABLE and INSERT statements
are left.

### Manual Startup Test of DB

```
docker run -d -p 5432:5432 \
        -e POSTGRES_PASSWORD=jira \
        -e POSTGRES_USER=jira \
        -v $(pwd)/initdb.d:/docker-entrypoint-initdb.d/ \
        postgres:9.4
```




