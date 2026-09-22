# llm-gateway

A small Docker proxy. Callers send OpenRouter-style `/v1/...` requests to this server. The server forwards only those paths to `https://openrouter.ai/api/v1/` and returns the response. Any other path, including `/`, is a 404.

## What it does not do

It does not serve a website, a logo, or docs. The public address is this machine's IP, or a neutral hostname you choose. Do not put a vendor name in that hostname.

## Run

```bash
cp .env.example .env
docker compose up -d --build
```

Leave `OPENROUTER_API_KEY` empty to forward the caller's `Authorization` header. That is the same OpenRouter key the caller already uses. Set the variable if this server should store one key and send it for every request.

## Call

```bash
curl http://SERVER/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY"
```

Chat requests use the same path as OpenRouter, for example `/v1/chat/completions`. Streaming responses are passed through.

## How this was set up

1. Nginx in Docker listens on port 80.
2. `/v1/` is proxied to `https://openrouter.ai/api/v1/` with the `Host` header set to `openrouter.ai`.
3. `/` returns 404.
4. The image entrypoint uses a stored key when `OPENROUTER_API_KEY` is set, and otherwise keeps the caller's header.
5. The same compose file is running on each server under `/opt/llm-gateway`. The API key is not in this repository.
