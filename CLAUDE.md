# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Browsidian is a zero-dependency Node.js web app for browsing and editing an Obsidian vault in the browser. It runs a local HTTP server that serves a vanilla JS frontend and exposes a REST API for file operations.

## Running the Server

```bash
# With vault path as env var
OBSIDIAN_VAULT=/path/to/vault npm start

# With vault path as CLI arg
node server.js --vault /path/to/vault

# Custom host/port
node server.js --host 0.0.0.0 --port 3000
# OR
HOST=0.0.0.0 PORT=3000 npm start
```

Default port: **5173**, default host: **127.0.0.1**

## Architecture

Single-file server (`server.js`, ~550 lines) with no npm dependencies — uses only Node.js built-ins (`http`, `fs`, `path`).

**Operating modes:**
- **Server mode** — reads/writes files in the configured vault directory (`OBSIDIAN_VAULT`)
- **Browser mode** — uses the File System Access API (Chrome/Edge/Brave)
- **Demo mode** — in-browser localStorage vault
- **Dropbox mode** — proxies to Dropbox API (requires `DROPBOX_APP_KEY`/`DROPBOX_APP_SECRET`)

**API endpoints** (all under `/api/`):
- `GET /api/config` — app version and vault name
- `GET /api/health` — health check
- `GET /api/list?dir=path` — list directory
- `GET /api/read?path=file.md` — read file
- `PUT /api/write` — write file
- `POST /api/move`, `/api/delete`, `/api/mkdir` — file operations
- `/*` — static file serving from `public/`

Security: path traversal is blocked via `ensureInsideVault()`. Hidden dirs (`.obsidian`, `.git`, `node_modules`, `.trash`) are ignored.

## Docker

The Dockerfile (in this directory) builds a node:22-alpine image. Key env vars for container use:
- `OBSIDIAN_VAULT` — path inside the container (mount your vault here, default `/vault`)
- `HOST` — set to `0.0.0.0` in the image so the server is reachable outside the container
- `PORT` — defaults to `5173`

In the parent `pingora-docker` project, the vault is mounted from `OBSIDIAN_VAULT_HOST` on the host into `/vault` in the container (read-only).
