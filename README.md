# Protocols

This project is a sandbox to try out various serialisation protocols and
toolchains and evaluate the level of support available on the BEAM.


## JSON Type Definition

[JSON Type Definition](https://jsontypedef.com/) is an alternative for JSON Schema
optimised for code generation. It's formally described by
[RFC 8927](https://datatracker.ietf.org/doc/html/rfc8927).
There are validator and code generator implementations available for
multiple languages, including Elixir (unofficial library tested in this project) and C#.


## Apache Avro

[Avro](https://avro.apache.org/) is an Apache Foundation data serialisation system. It defines a binary
data format and a JSON-based schema description format.

The schema definition languages seems to be a bit more heavywieght than JTD
and lacks some types which would be handy to have, e.g. ISO 8601
formatted datetime strings.

On the other hand, the binary data format offers better data compaction.
Avro also offers message compression, possibly offering even better space optimisation.
The JSON to Avro size ratio of a simple record without compression is approx. 3 to 1
(`user.2.json` vs `user.2.plain.avro`):

```
-rw-r--r--@  1 erszcz  staff    87B Aug  9 14:06 user.2.json
-rw-r--r--@  1 erszcz  staff   314B Aug  9 17:33 user.2.ocf.avro
-rw-r--r--@  1 erszcz  staff    26B Aug  9 15:32 user.2.plain.avro
```

Embedding the schema into an Avro message leads to a significant overhead,
but enables the message to be decoded without sharing the schema over a different channel.
