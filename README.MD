# RINHA 02

- Node Express
- Postgres
- nginx

## Docker compose

We use docker compose to initiate this project.
```
docker-compose up
```
## How to populate the DB with users

Look into the `populate.sql` file for the correct syntax.

```
curl -X POST -H "Content-Type: application/json" -d "$JSON_DATA" "$BASE_URL"
```

## ~~Setup network~~
Reference: https://docs.docker.com/get-started/07_multi_container/

```
docker network create rinha-002 
```

## ~~Setup volume~~

```
docker volume create db-data
```

Add the following to the mounted container
```
# -v db-data:/var/lib/postgresql/data
# not sure if the above is equivalent
--mount type=volume,src=db-data,target=/etc/db-data
```



## Start the API container
First build the image

```
docker build -t rinha-002-express-app .
```

Then run it
```
docker run -d -p 3000:1234 \
 --name api \
 --network rinha-002 \
 --network-alias express-app \
    rinha-002-express-app
```

### Tip for quick redeploys
```
docker stop api && docker remove api && docker build -t rinha-002-express-app . && docker run -d -p 3000:1234 --name api --network rinha-002 --network-alias express-app rinha-002-express-app && docker ps && docker logs -f api
```

## Start the DB container
Reference: https://hub.docker.com/_/postgres

- Note: Docker recognizes you want to use a named volume and creates one automatically for you.
- Log in to the container and run `psql -U postgres` to access the database.

```
docker run -d \
    --name db \
    --network rinha-002 \
    --network-alias pg \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
	-v db-data:/var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=secret \
    postgres
```

If it was MySQL, [it would be](https://docs.docker.com/get-started/07_multi_container/):
```
docker run -d \
    --network rinha-002 --network-alias mysql \
    -v db-data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=todos \
    mysql:8.0
```

If you need to inspect the container, run:
```
docker exec -it f7826470b6eb sh
```

### SQL cheat sheet

Check for dbs
```
\l
\dt
\d your_table_name
\conninfo
SELECT * FROM your_table_name;
```
### init.sql

The script contains the CREATE db and CREATE table statements. **Check the script for the correct syntax.**

```
CREATE TABLE IF NOT EXISTS usuarios
(
    id
               SERIAL
        PRIMARY
            KEY,
    apelido
               VARCHAR(32) NOT NULL unique,
    nome      VARCHAR(100) NOT NULL,
    nascimento      DATE NOT NULL,
    stack     VARCHAR(32)[] CHECK (array_length(stack, 1) IS NULL OR NOT NULL = ALL(stack))
);
```

### Stop a container

```
docker stop 954e84af4d6e
```