<!-- vim: set ft=markdown: -->
# Common interface for external and internal services

## first iteration

- Service declaration interface `provides`
- Service discovery interface:
  - `ServiceEndpoint` class
  - `endpoint_for`, `find_endpoint`
- Service discovery backends
  - Chef node index
  - Chef data bag
- Backend selection configuration


