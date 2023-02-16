## GraphQL Generator

Aplicación de línea de comandos para automatizar la creación de los fragmentos, consultas y mutaciones de un `schema.graphql`.

### Activación de la aplicación

Mediante el siguiente comando se activa localmente la aplicación. Es importante ubicarse en el `pubspec.yaml` del proyecto.

```
~$ dart pub global activate --source path .
```

También se puede ejecutar el comando mediante el `Makefile`.

```
~$ make activate
```

### Ejecución de la aplicación

Para ejecutar la generación de los archivos basta con ejecutar el siguiente comando:

```
~$ gql_generator [-p | --path] <ruta-del-archivo-schema.graphql>
```
