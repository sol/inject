# Inject: A minimalistic template engine

Inject expands shell commands in arbitrary text templates.

## Example

Given a file `input.txt` with

```
My {{echo -n fancy}} template!
```

When I run `inject < input.txt` I get

```
My fancy template!
```
