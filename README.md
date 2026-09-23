# llm-gateway

A small Docker proxy. Callers send OpenRouter-style requests to `/v1/...` or `/api/v1/...`. The server forwards only those paths to `https://openrouter.ai/api/v1/` and returns the response. Any other path, including `/`, is a 404.

## What it does not do

It does not serve a website, a logo, or docs. The public address is this machine's IP, or a neutral hostname you choose. Do not put a vendor name in that hostname.

## Run

```bash
cp .env.example .env
docker compose up -d --build
```

The caller's `Authorization` header is sent to OpenRouter when it is present. If the caller omits it and `OPENROUTER_API_KEY` is set on the server, that stored key is used instead.

## Add a server key later

On the server, from `/opt/llm-gateway`:

```bash
printf 'OPENROUTER_API_KEY=%s\n' 'YOUR_KEY' > .env
chmod 600 .env
docker compose up -d --force-recreate
```

Callers can still send their own key. The stored key is only the fallback. The `.env` file stays on the host and is not committed.

To remove the fallback:

```bash
printf 'OPENROUTER_API_KEY=\n' > .env
docker compose up -d --force-recreate
```

## Call

```bash
curl http://SERVER/api/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY"
```

`/v1/models` is the same list. Chat requests use `/api/v1/chat/completions` or `/v1/chat/completions`. Streaming responses are passed through.

## How this was set up

1. Nginx in Docker listens on port 80.
2. `/v1/` and `/api/v1/` are proxied to `https://openrouter.ai/api/v1/` with the `Host` header set to `openrouter.ai`.
3. `/` returns 404.
4. A caller key wins. A key in `.env` is used only when the request has no `Authorization` header.
5. The same compose file is running on each server under `/opt/llm-gateway`. The API key is not in this repository.
