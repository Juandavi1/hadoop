create table if not exists users(name string);

insert into users values ('vale'),('bonilla');

load data local inpath '/home/bigdata/working/hive/data.txt' into table users;

select u.* from users u;