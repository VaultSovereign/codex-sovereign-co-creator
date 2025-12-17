# Codex Sovereign Co‑Creator

Small “prompt pack + wrapper script” to run Codex CLI in a *sovereign* workflow: you stay in control, Codex proposes and executes with explicit approvals.

## What’s here

- `scripts/codex-sovereign` — run Codex with the Sovereign Co‑Creator base prompt
- `prompts/sovereign-co-creator.md` — the base prompt (v1.1, edit to taste)
- `scripts/fetch-openai-platform-overview.sh` — best‑effort downloader for the Platform “Overview” docs + fallback instructions
- `docs/openai-platform-overview.SUMMARY.md` — offline summary (because direct download is often blocked by Cloudflare)
- `docs/CAPABILITY_POLICY.md` — capability authority matrix (L1/L2/L3, hot/cold, approvals, expected evidence)

## Quickstart

Run against any repo/project:

```bash
/root/work/codex-sovereign-co-creator/scripts/codex-sovereign \
  -C /root/work/vaultmesh \
  "Add a command that prints the current version"
```

If `codex` isn’t on your `PATH`, export:

```bash
export PATH="$HOME/.npm-global/bin:$PATH"
```

If you installed `codex` globally via `npm`, this is often correct too:

```bash
export PATH="$(npm prefix -g)/bin:$PATH"
```

For Termux (or Kali running under Termux/proot), this is the common prefix:

```bash
export PATH="$PREFIX/bin:$PATH"
```

## Troubleshooting

Detect where `codex` is installed (and print the right `PATH` export):

```bash
bash /root/work/codex-sovereign-co-creator/scripts/codex-detect
```

## Fetching official Platform docs

The URL `https://platform.openai.com/docs/overview` is commonly protected by Cloudflare, which blocks `curl` and headless Chromium. Use:

```bash
/root/work/codex-sovereign-co-creator/scripts/fetch-openai-platform-overview.sh
```

If it reports “blocked”, open the URL in a real browser and **Save Page As…** into `work/codex-sovereign-co-creator/docs/`.
