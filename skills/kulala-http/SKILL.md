---
name: kulala-http
description: Create, edit, review, or troubleshoot Kulala.nvim and kulala-core REST client .http and .rest files, request chaining, scripts, and http-client.env.json environments.
---

# Kulala HTTP files

Use this skill when working on HTTP request files or their environment files intended for Kulala.nvim/kulala-core. Follow the target project's conventions, inspect the installed Kulala version and relevant docs, and distinguish verified behavior from assumptions inherited from another REST client. When delegating this work, explicitly tell the worker to read and follow this skill; automatic skill selection is not guaranteed.

## Workflow

1. Inspect existing request and environment files, the selected environment, `.gitignore`, and relevant API documentation without exposing credentials. Preserve the project's endpoints, authentication flow, request names, and formatting unless the user asks to change them.
2. Write Kulala-compatible requests and keep public configuration separate from secrets. Use the actual response schema to choose JSONPath expressions. Do not invent API paths, payloads, authentication, or successful results.
3. Validate with the installed Kulala version and, where practical, a harmless local mock. Run requests with side effects, real credentials, or external endpoints only when authorized and appropriate. Never print or commit tokens or secrets.
4. Report what was verified, what was not run, the environment and Kulala version if known, and any version-specific caveats.

## Requests and chaining

- Use `### requestName` to delimit and name a request, then the HTTP method, URL, headers, blank line, and optional body. Use `{{name}}` for variables from the selected HTTP environment or in-file variables.
- For chained named-response references, put `# @kulala-vscode-restclient-compat` in the file header, before the first `###`. Use JSONPath after `body.`, e.g. `{{issueToken.response.body.$.access_token}}`, not `{{issueToken.response.body.access_token}}`. For a header, the form is `{{issueToken.response.headers.Content-Type}}` or `{{issueToken.response.headers['Content-Type']}}`.
- Run the named source request successfully first, then the dependent request against the same document and selected environment. The core may persist named responses across separate runs; re-run the source when a response is missing, expired, or stale. Named responses may contain secrets: protect or clean local response stores and logs as appropriate.
- A verified local `kulala-core` 0.28.1 quirk: in-file `@name=value` definitions can be scoped to a `###` section. Put shared `@` definitions at the top of the file before any `###` delimiter, or use the selected environment file; do not assume a definition beneath an earlier delimiter is global. Re-test on the actual installed version.

Illustrative local-mock request file (the mock must return an `access_token` property; this is not a real API):

```http
# @kulala-vscode-restclient-compat
@tenant = demo

### issueToken
POST {{baseUrl}}/token
Content-Type: application/json

{"clientId":"{{clientId}}"}

### profile
GET {{baseUrl}}/profile
Authorization: Bearer {{issueToken.response.body.$.access_token}}
X-Tenant: {{tenant}}
```

Select `local` from the neighboring `http-client.env.json`:

```json
{
  "local": {
    "baseUrl": "http://127.0.0.1:8765",
    "clientId": "example-client"
  }
}
```

The mock should accept `/token` and return JSON such as `{"access_token":"mock-token"}`; `/profile` should check the bearer token and tenant. Start a mock on the chosen loopback port before running either request. Change the example port if needed.

## Environments and secrets

- Put named, non-secret values in `http-client.env.json`; select the desired environment in Kulala. Put sensitive values in `http-client.private.env.json` or supported secret management, and ensure the private file is actually ignored by Git. Never hard-code or log secrets. Private values override public values for the same environment key.
- Use `{{baseUrl}}` for an HTTP-environment value and `{{ $env.API_TOKEN }}` for a process environment variable. Do not assume `{{API_TOKEN}}` reads the process environment. Inspect project configuration and environment precedence when a value resolves unexpectedly.
- Do not disable TLS verification as a workaround for an unexplained authentication or connectivity error. If the user explicitly requires a temporary insecure option, explain its security implications and limit its scope.

## Scripts and current-core migration pitfalls

- Use per-request script includes such as `< ./scripts/pre-request.js` for shared pre-request logic. External script paths are relative to the `.http` file. Check the installed core's script language/API before relying on extensions, and test scripts using the actual client.
- In current kulala-core, `### KULALA_SHARED` and `### KULALA_SHARED_EACH` are ordinary named blocks, not shared wrappers. Older `### Shared` conventions should not be assumed to inject scripts or metadata. For shared headers and curl options, consider the documented `$kulala.defaults` in the environment file, checking the installed version.
- Current core's curl metadata uses `# @kulala-curl--location` for `--location` (and `# @kulala-curl--insecure` for `--insecure`), not legacy `# @curl-location` or `# @curl-insecure`. Verify version support; avoid insecure flags unless explicitly justified.

## Validation checklist

- [ ] The selected environment resolves every expected variable; no placeholders or secrets leak into output.
- [ ] The source request has run first, and the dependent request receives the intended JSONPath value and headers.
- [ ] Request format, scripts, and options work with the installed client rather than only another REST client.
- [ ] Any shared `@` variables are positioned before all `###` delimiters for compatibility with the verified 0.28.1 behavior.
- [ ] Public and private environment files have the correct roles, and private data is ignored and not committed.
- [ ] Only safe, authorized requests were executed; unverified behavior is identified.

References: https://kulala.app/usage, https://kulala.app/usage/environments, https://kulala.app/usage/request-variables, https://kulala.app/usage/migration.
