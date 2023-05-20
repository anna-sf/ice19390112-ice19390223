Project for Cloud Computing, made by ice19390112 and ice19390223
========================

This virtual lab was created as the final project for the subject of Cloud Computing, for the 8th semester of the Computer Engineering course, in the University of West Attica. 

It was created in Ubuntu version 18.04, using Oracle's Virtual Box, and with the help of the latest release of Docker and MySQL.

## Run

To run this virtual lab, you need to download:
1.Ubuntu 18.04
2.Latest release of Docker
3.Latest release of MySQl

Once the above are downloaded, you need to run these commands:


#### Create 2 MySQL containers with master-slave row-based replication 

```bash
mkdir master 
mkdir slave
touch master/master.env
touch slave/slave.env
docker-compose up -d
docker-compose exec master bash
mysql -u root -p
```

#### Make changes to master

```bash
docker exec mysql_master sh -c "export MYSQL_PWD=abc123; mysql -u root Students -d 'create table Students_info(
	AM int,
	LastName varchar(255),
	FirstName varchar(255),
	Address varchar(255),
	Semester int,
	Passed_Subjects int,
	Declared_Subjects int );
  insert into Students_info values ('19390112', 'Kostoulas', 'Aggelos', 'Athens', '8', '25', '8');
```

#### Read changes done to master from slave

```bash
docker exec slave sh -c "export MYSQL_PWD=abc123; mysql -u root mydb -d 'select * from code \G'"
```


## Check Logs
In order to check the logs you can run these commands

```bash
docker-compose logs (insert name or ID)
```

##Start Container

```bash
./build.sh
```

##Check which containers are running

```bash
docker-compose ps
```


#### How to enter into MySQL

Master in MySQL

```bash
docker exec -it master bash
```
Slave in MySQL

```bash
docker exec -it slave bash
