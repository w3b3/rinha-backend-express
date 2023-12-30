-- init.sql

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

-- insert into users (name, email)
-- values ('daniel', 'daniel@foo.bar');

-- Add more initialization queries as needed
