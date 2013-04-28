# Inject the output of shell commands into arbitrary text templates

## Example

Given a file `input.txt` with

```
My {{{echo fancy}}} template!
```

When I run `inject < input.txt` > output.txt` I get

```
My fancy template!
```
