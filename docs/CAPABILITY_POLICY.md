# Capability Policy (Codex / MCP / VaultMesh)

This document is the **Capability Authority Matrix** for this Codex environment, mapped onto the **VaultMesh Eternal Pattern** layers (**L1/L2/L3**).

It defines:
- which tools are **hot vs cold** (side effects / irreversibility)
- which tools require **operator approval**
- what **evidence** should exist after use (receipts / scrolls / roots / anchors)

## Definitions

### Layers (Eternal Pattern)

VaultMesh’s canonical stack:
- **L1 — Experience:** intent in / queries (CLI, UI, MCP tools, agents)
- **L2 — Engine:** plan + execute domain work (runners, state machines, scanners)
- **L3 — Ledger:** receipts / scrolls / proofchain / roots / anchors

### Hotness (risk classification)

Deeper rule:
> **Anything that advances time, state, or commitment is Hot** — even if it’s “benign”.

- **Cold:** observe/read-only; no state/time/commitment advances
- **Warm:** mostly observational but may touch the network/targets or produce artifacts; treat as **Confirm** when uncertain
- **Hot:** mutates local/remote state, starts/changes ongoing posture, advances the ledger frontier, or commits externally

### Approval tiers (suggested)

- **None:** safe to run without asking (still constrained by sandbox/network policy)
- **Confirm:** ask each time
- **Break-glass:** explicit justification; use rarely
- **Dual-control:** require a second human/out-of-band check before execution

## Capability Authority Matrix

| Tool / group | Layer | Hot/Cold | Recommended approval | Expected evidence (receipt/scroll) |
|---|---:|---:|---|---|
| MCP discovery/reads (`list_mcp_*`, `read_mcp_resource`) | L1 | Cold | None | CLI output (receipt only if you mint one) |
| FS reads (`mcp__filesystem__read_*`, `...__list_*`, `...__search_files`, `...__get_file_info`) | L1 | Cold | None | CLI output |
| FS mutation (`...__write_file`, `...__edit_file`, `...__move_file`, `...__create_directory`) | L2 | Hot | Confirm | Diff + filesystem changes (optionally `proof_generate`) |
| Patch application (`apply_patch`) | L2 | Hot | Confirm | Diff + filesystem changes (optionally `proof_generate`) |
| Local shell execution (`shell_command`) | L2 | Hot | Confirm (escalate if network/outside sandbox) | Command transcript (optionally `proof_generate`) |
| Oracle think/choose (`...__oracle_status`, `...__oracle_reason`, `...__oracle_decide`) | L2 | Cold | None | Decision record (receipt only if you mint one) |
| Oracle chain (`...__oracle_tactical_chain`) | L2→L3 | Cold if `dry_run=true`, else Hot | Confirm when executing | Signed chain/receipt (by design) |
| Tactical execution (`...__tactical_execute`, `...__tactical_playbook`) | L2 | Hot | Confirm | Command/playbook log + outputs |
| Tactical learning (`...__tactical_learn`) | L2 | Hot | Confirm | State mutation (“learned”) record |
| Recon (passive) (`...__recon_passive`) | L2 | Warm | Confirm if it uses network | Findings report/artifacts |
| Recon (touch) (`...__recon_active`, `...__recon_wifi`) | L2 | Hot | Confirm + explicit `authorization` | Scan artifacts + authorization reference |
| Shield status (`...__shield_status`) | L1 | Cold | None | Status output |
| Shield monitoring (`...__shield_monitor`) | L2 | Hot | Confirm | Monitoring-state change record |
| Shield response (`...__shield_respond`) | L2 | Hot | Confirm / Break-glass | Response record + downstream effects |
| Mesh observe (`...__mesh_status/topology/alerts/backups/blast_radius/console_ping/listen`) | L1 | Cold | None (may need network approval) | Telemetry output |
| Mesh mutation (`...__mesh_broadcast`, `...__mesh_join`) | L2 | Hot | Confirm | Broadcast/join record |
| Router list (`...__router_list`) | L1 | Cold | None | Workflow inventory |
| Router define/run (`...__router_workflow`, `...__router_run`) | L2 | Hot | Confirm | Workflow definition + run record |
| Agents/missions observe (`...__agent_list/status`, `...__mission_list/status`, `...__orchestrator_status`) | L1 | Cold | None | Status output |
| Agents/missions mutate (`...__agent_task/cancel`, `...__mission_create/assign`, `...__agent_spawn`) | L2 | Hot | Confirm | Task/mission record |
| Agent kill (`...__agent_kill`) | L2 | Hot | Break-glass / Dual-control | Termination record + rationale |
| AppSec scanners (`...__semgrep_scan`, `...__nuclei_scan`, `...__trivy_scan`, `...__grype_scan`, `...__syft_sbom`, `...__gitleaks_scan`, `...__trufflehog_scan`, `...__checkov_scan`) | L2 | Warm | Confirm if network/DB updates | Findings/SBOM outputs |
| Proof inspect (`...__proof_verify/chain/stats/anchor_status/anchor_verify/braid_status`) | L3 | Cold | None | Verification output |
| Proof create (`...__proof_generate`, `...__proof_batch`, `...__proof_root`) | L3 | Hot | Confirm | New proof/batch + updated root artifacts |
| Proof braid/anchor (`...__proof_anchor*`, `...__proof_braid_emit/import`, `...__vaultmesh_pull_root`) | L3 | Hot | Confirm / Dual-control for external anchoring | Anchor/braid receipts + external attestations |
| Guardian status/verify (`mcp__vaultmesh__guardian_status`, `...__guardian_verify_receipt`) | L3 | Cold | None | Scroll query/verification output |
| Guardian anchor (`...__guardian_anchor_now`) | L3 | Hot | Dual-control | Anchor receipt + updated root |
| Treasury balance (`...__treasury_balance`) | L3 | Cold | None | Balance output |
| Treasury mutate (`...__treasury_create_budget/credit`) | L3 | Hot | Confirm | Treasury receipt/ledger entry |
| Treasury debit (`...__treasury_debit`) | L3 | Hot | Dual-control | Treasury receipt/ledger entry |

## Notes

- **Network policy wins:** even “Cold” tools may require approval if they need network access in a restricted environment.
- **`proof_root` is Hot by default:** it writes `data/ROOT.txt` (or equivalent) and advances the ledger frontier.
- **Hot ≠ harmful:** “benign” actions can still be **irreversible** (posture changes, committed evidence, external anchors).
