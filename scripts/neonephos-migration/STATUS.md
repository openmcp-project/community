# NeoNephos Migration Status

Tracking the SAP → NeoNephos/OpenControlPlane reference removal across all `openmcp-project` repos.

**Epic:** https://github.com/openmcp-project/backlog/issues/533  
**Guidelines:** [NeoNephos Project Guidelines](https://github.com/neonephos/guidelines-development/blob/main/project-guidelines/project-guidelines.md) (Sections 7, 9, 12)

## PRs

### Tier 1 — Pilot (draft, awaiting review)

| Repo | PR | Status |
|------|----|--------|
| openmcp | [#315](https://github.com/openmcp-project/openmcp/pull/315) | Draft |
| openmcp-operator | [#286](https://github.com/openmcp-project/openmcp-operator/pull/286) | Draft |
| bootstrapper | [#210](https://github.com/openmcp-project/bootstrapper/pull/210) | Draft |

### Docs website

| Change | PR | Status |
|--------|----|--------|
| Fix LF Europe footer text | [docs#88](https://github.com/openmcp-project/docs/pull/88) | Open |
| Add Osano cookie consent script | [docs#89](https://github.com/openmcp-project/docs/pull/89) | Open |

### Tiers 2–5

Not yet started. Will proceed after tier 1 is reviewed and merged.

## What the script does

Per repo:
1. Replace SPDX copyright headers (`SAP SE or an SAP affiliate company` → `OpenControlPlane contributors`)
2. Replace/create `REUSE.toml` from standard template
3. Replace SAP contact emails (`ospo@sap.com` → `support@neonephos.org`)
4. Clean CONTRIBUTING.md (remove SAP OSPO references, fix CoC link title)
5. Remove SAP legal/policy links from markdown files
6. Remove repo-local community health files now inherited from `.github`
7. Add required LF Europe footer + ApeiroRA funding notice to README.md
8. Flag BTP doc links (`help.sap.com`) for manual review

## Correct LF Europe footer (§7)

```
Copyright Linux Foundation Europe. For web site terms of use, trademark policy and other project policies please see https://linuxfoundation.eu/en/policies.
```

## Not in scope (tracked separately)

- `sap.com/v1alpha1` API group rename — requires API breaking change, separate TSC discussion
- `ghcr.io/sap` container image mirroring — functional dependency, separate effort
- BTP technical doc links (`help.sap.com/docs/btp/*`) — valid external references, kept as-is
- DCO enforcement (§5) — needs repo branch protection rule changes
- Private vulnerability reporting (§6) — needs GitHub security advisory setup per repo
