#!/usr/bin/env bash
set -uo pipefail

# NeoNephos Migration Script
# Replaces SAP references across openmcp-project repos per NeoNephos Foundation guidelines.
# Part of https://github.com/openmcp-project/backlog/issues/533

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_FILE="${SCRIPT_DIR}/repos.txt"
REUSE_TEMPLATE="${SCRIPT_DIR}/reuse-template.toml"
WORK_DIR="${NEONEPHOS_WORK_DIR:-${SCRIPT_DIR}/../.migration-workspace}"
REPORT_FILE="${SCRIPT_DIR}/migration-report.txt"
BRANCH_NAME="chore/neonephos-copyright-update"
ORG="openmcp-project"

DRY_RUN=false
SKIP_CLONE=false
SINGLE_REPO=""
TIER=""
DRAFT_PR=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --dry-run         Preview changes without committing or pushing
  --draft           Create PRs in draft mode
  --skip-clone      Reuse existing clones in workspace dir
  --repo <name>     Process a single repo instead of the full list
  --tier <n>        Process only repos in tier N (1-5)
  -h, --help        Show this help

Examples:
  $(basename "$0") --dry-run                    # Preview all changes
  $(basename "$0") --repo openmcp --dry-run     # Preview one repo
  $(basename "$0") --tier 1 --draft             # Pilot repos, draft PRs
  $(basename "$0")                              # Full run, all repos
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)   DRY_RUN=true; shift ;;
        --draft)     DRAFT_PR=true; shift ;;
        --skip-clone) SKIP_CLONE=true; shift ;;
        --repo)      SINGLE_REPO="$2"; shift 2 ;;
        --tier)      TIER="$2"; shift 2 ;;
        -h|--help)   usage ;;
        *)           echo "Unknown option: $1"; usage ;;
    esac
done

# Parse repos.txt — skip comments and blank lines
get_repos() {
    if [[ -n "$SINGLE_REPO" ]]; then
        echo "$SINGLE_REPO"
        return
    fi

    local current_tier=0
    while IFS= read -r line; do
        if [[ "$line" =~ ^##\ Tier\ ([0-9]) ]]; then
            current_tier="${BASH_REMATCH[1]}"
            continue
        fi
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        if [[ -z "$TIER" || "$current_tier" == "$TIER" ]]; then
            echo "$line"
        fi
    done < "$REPOS_FILE"
}

# Initialize report
init_report() {
    cat > "$REPORT_FILE" <<EOF
# NeoNephos Migration Report
# Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
# Mode: $(if $DRY_RUN; then echo "DRY RUN"; else echo "LIVE"; fi)

EOF
}

report() {
    echo "$*" | tee -a "$REPORT_FILE"
}

# Replace copyright headers in source files
replace_copyright_headers() {
    local repo_dir="$1"

    # Find all text files, skip vendor/ and .git/
    find "$repo_dir" -type f \
        -not -path '*/.git/*' \
        -not -path '*/vendor/*' \
        -not -path '*/node_modules/*' \
        -not -name 'REUSE.toml' \
        | while read -r file; do
        # Only process files that actually contain the SAP copyright
        if grep -q "SAP SE or an SAP affiliate company" "$file" 2>/dev/null; then
            # // style (Go, Java, Proto, C)
            sed -i '' 's|// SPDX-FileCopyrightText:.*SAP SE or an SAP affiliate company.*|// SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.|g' "$file"
            # # style (Shell, YAML, Python, TOML)
            sed -i '' 's|# SPDX-FileCopyrightText:.*SAP SE or an SAP affiliate company.*|# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.|g' "$file"
            # <!-- --> style (HTML, XML)
            sed -i '' 's|<!-- SPDX-FileCopyrightText:.*SAP SE or an SAP affiliate company.*-->|<!-- SPDX-FileCopyrightText: Copyright OpenControlPlane contributors. -->|g' "$file"
            # Catch any remaining "SAP SE or an SAP affiliate company" in SPDX lines
            sed -i '' 's|SPDX-FileCopyrightText:.*SAP SE or an SAP affiliate company.*|SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.|g' "$file"
        fi

        # README footer pattern: "Copyright 20XX SAP SE or an SAP affiliate company and <name> contributors"
        if grep -q "Copyright.*SAP SE or an SAP affiliate company" "$file" 2>/dev/null; then
            sed -i '' 's|Copyright [0-9]* SAP SE or an SAP affiliate company and .* contributors|Copyright OpenControlPlane contributors|g' "$file"
            # Legacy format: "Copyright 20XX Copyright (c) 20XX SAP SE or an SAP affiliate company. All rights reserved..."
            sed -i '' 's|// Copyright [0-9]* Copyright (c) [0-9]* SAP SE or an SAP affiliate company\. All rights reserved\..*|// Copyright OpenControlPlane contributors. Licensed under the Apache License, Version 2.0.|g' "$file"
            # Catch remaining "SAP SE or an SAP affiliate company" in any Copyright line
            sed -i '' 's|Copyright.*SAP SE or an SAP affiliate company.*contributors|Copyright OpenControlPlane contributors|g' "$file"
            sed -i '' 's|Copyright.*(c).*SAP SE or an SAP affiliate company.*|Copyright OpenControlPlane contributors.|g' "$file"
        fi

        # SAP Code of Conduct link pattern
        if grep -q "github.com/SAP/" "$file" 2>/dev/null; then
            sed -i '' 's|https://github.com/SAP/\.github/blob/main/CODE_OF_CONDUCT\.md|https://github.com/openmcp-project/.github/blob/main/CODE_OF_CONDUCT.md|g' "$file"
        fi
    done
}

# Replace REUSE.toml with standard template (or migrate dep5 → REUSE.toml)
replace_reuse_toml() {
    local repo_dir="$1"
    local repo_name="$2"

    # If dep5 exists, remove it (deprecated per REUSE spec 3.3) and create REUSE.toml
    if [[ -f "${repo_dir}/.reuse/dep5" ]]; then
        rm "${repo_dir}/.reuse/dep5"
        rmdir "${repo_dir}/.reuse" 2>/dev/null || true
        sed "s|REPO_NAME_PLACEHOLDER|${repo_name}|g" "$REUSE_TEMPLATE" > "${repo_dir}/REUSE.toml"
        report "  [OK] Migrated .reuse/dep5 → REUSE.toml"
    elif [[ -f "${repo_dir}/REUSE.toml" ]]; then
        sed "s|REPO_NAME_PLACEHOLDER|${repo_name}|g" "$REUSE_TEMPLATE" > "${repo_dir}/REUSE.toml"
        report "  [OK] REUSE.toml replaced"
    else
        report "  [SKIP] No REUSE.toml or dep5 found"
    fi
}

# Replace SAP contact emails
replace_contacts() {
    local repo_dir="$1"

    find "$repo_dir" -type f \
        -not -path '*/.git/*' \
        -not -path '*/vendor/*' \
        | while read -r file; do
        if grep -q "ospo@sap.com\|privacy@sap.com" "$file" 2>/dev/null; then
            sed -i '' 's|ospo@sap.com|support@neonephos.org|g' "$file"
            sed -i '' 's|privacy@sap.com|support@neonephos.org|g' "$file"
            report "  [OK] Replaced SAP emails in $(basename "$file")"
        fi
    done
}

# Clean up CONTRIBUTING.md SAP references
clean_contributing() {
    local repo_dir="$1"
    local contrib="${repo_dir}/CONTRIBUTING.md"

    [[ -f "$contrib" ]] || return 0

    if grep -q "SAP Open Source Code of Conduct" "$contrib" 2>/dev/null; then
        sed -i '' 's|SAP Open Source Code of Conduct|Code of Conduct|g' "$contrib"
        report "  [OK] Renamed 'SAP Open Source Code of Conduct' → 'Code of Conduct'"
    fi

    if grep -q "SAP Open Source Program Office" "$contrib" 2>/dev/null; then
        sed -i '' '/(SAP Open Source Program Office)/d' "$contrib"
        report "  [OK] Removed SAP OSPO reference from CONTRIBUTING.md"
    fi
}

# Remove SAP legal/policy links (lines containing them)
remove_sap_legal_links() {
    local repo_dir="$1"

    find "$repo_dir" -type f \( -name "*.md" -o -name "*.html" \) \
        -not -path '*/.git/*' \
        -not -path '*/vendor/*' \
        | while read -r file; do
        if grep -q "www\.sap\.com/about/legal\|www\.sap\.com/corporate/en/legal\|www\.sap\.com/content/dam/application/shared/logos" "$file" 2>/dev/null; then
            sed -i '' '/www\.sap\.com\/about\/legal/d' "$file"
            sed -i '' '/www\.sap\.com\/corporate\/en\/legal/d' "$file"
            sed -i '' '/www\.sap\.com\/content\/dam\/application\/shared\/logos/d' "$file"
            report "  [OK] Removed SAP legal links from $(basename "$file")"
        fi
    done
}

# Flag BTP doc links for manual review (don't auto-replace)
flag_btp_links() {
    local repo_dir="$1"
    local repo_name="$2"

    find "$repo_dir" -type f \
        -not -path '*/.git/*' \
        -not -path '*/vendor/*' \
        | while read -r file; do
        grep -n "help\.sap\.com" "$file" 2>/dev/null | head -5 | while read -r match; do
            report "  [FLAG] ${repo_name}/$(echo "$file" | sed "s|${repo_dir}/||"):${match}"
        done
    done
}

# Remove repo-local files that are now inherited from .github org defaults
remove_inherited_files() {
    local repo_dir="$1"

    local inherited_files=(
        "CODE_OF_CONDUCT.md"
        "SECURITY.md"
        "CONTRIBUTING_USING_GENAI.md"
    )

    for f in "${inherited_files[@]}"; do
        if [[ -f "${repo_dir}/${f}" ]]; then
            # Only remove if it's the SAP-era version (contains SAP references)
            if grep -q "SAP\|ospo@sap.com" "${repo_dir}/${f}" 2>/dev/null; then
                rm "${repo_dir}/${f}"
                report "  [OK] Removed ${f} (now inherited from .github)"
            fi
        fi
    done
}

# Ensure README.md has the required NeoNephos/LFE footer (§7, §12)
ensure_readme_footer() {
    local repo_dir="$1"
    local readme="${repo_dir}/README.md"

    if [[ ! -f "$readme" ]]; then
        report "  [SKIP] No README.md found"
        return
    fi

    # Skip if footer already present
    if grep -q "Linux Foundation Europe" "$readme" 2>/dev/null; then
        report "  [SKIP] README.md already has LFE footer"
        return
    fi

    cat >> "$readme" <<'FOOTER'

---

<p align="center">
  <a href="https://apeirora.eu/content/projects/">
    <img alt="BMWK-EU funding logo" src="https://apeirora.eu/assets/img/BMWK-EU.png" width="300"/>
  </a>
</p>

<p align="center">
  OpenControlPlane is part of <a href="https://apeirora.eu/content/projects/">ApeiroRA</a>, an EU Important Project of Common European Interest (IPCEI-CIS).
</p>

<p align="center">
  Copyright Linux Foundation Europe. For web site terms of use, trademark policy and other project policies please see <a href="https://linuxfoundation.eu/en/policies">https://linuxfoundation.eu/en/policies</a>.
</p>
FOOTER

    report "  [OK] Added NeoNephos/LFE footer to README.md"
}

# Verify no SAP references remain (excluding allowed ones)
verify_clean() {
    local repo_dir="$1"
    local remaining

    remaining=$(grep -r "SAP SE or an SAP affiliate" "$repo_dir" \
        --include="*.go" --include="*.yaml" --include="*.yml" --include="*.toml" \
        -l 2>/dev/null \
        | grep -v "/.git/" \
        | grep -v "/vendor/" || true)

    if [[ -n "$remaining" ]]; then
        report "  [WARN] Remaining SAP copyright refs:"
        echo "$remaining" | while read -r f; do
            report "         $f"
        done
        return 1
    fi
    return 0
}

# Git operations
commit_and_push() {
    local repo_dir="$1"
    local repo_name="$2"

    (
    cd "$repo_dir"

    if [[ -z "$(git status --porcelain)" ]]; then
        report "  [SKIP] No changes to commit"
        return 0
    fi

    local changed_count
    changed_count=$(git status --porcelain | wc -l | tr -d ' ')
    report "  [GIT] ${changed_count} files changed"

    if $DRY_RUN; then
        report "  [DRY RUN] Would commit and push branch ${BRANCH_NAME}"
        git diff --stat
        return 0
    fi

    git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"
    git add -A
    git commit -s -m "chore: replace SAP references with NeoNephos/OpenControlPlane

Remove SAP copyright headers and policy references per NeoNephos
Foundation guidelines (Section 7, 9).

Part of https://github.com/openmcp-project/backlog/issues/533"

    git push origin "$BRANCH_NAME"

    local draft_flag=""
    if $DRAFT_PR; then
        draft_flag="--draft"
    fi

    GH_HOST=github.com gh pr create \
        --repo "${ORG}/${repo_name}" \
        --head "$BRANCH_NAME" \
        $draft_flag \
        --title "chore: replace SAP references with NeoNephos/OpenControlPlane" \
        --body "$(cat <<'PRBODY'
## What

Replace SAP-era copyright headers and policy references with NeoNephos/OpenControlPlane equivalents.

- Copyright headers: `SAP SE or an SAP affiliate company` → `OpenControlPlane contributors`
- REUSE.toml: updated to neutral template
- Contact emails: `ospo@sap.com` → `support@neonephos.org`
- Removed SAP legal/policy links
- Removed repo-local community health files now inherited from `.github`
- Added required NeoNephos/LF Europe footer to README.md (§7, §12)

**Not changed:** BTP doc links, `ghcr.io/sap` images, `sap.com/v1alpha1` API group.

## Why

Per [NeoNephos Project Guidelines](https://github.com/neonephos/guidelines-development/blob/main/project-guidelines/project-guidelines.md) (Sections 7, 9). Part of https://github.com/openmcp-project/backlog/issues/533.
PRBODY
)" 2>&1 | tee -a "$REPORT_FILE"

    report "  [OK] PR created for ${repo_name}"
    )
}

# Main
main() {
    init_report
    mkdir -p "$WORK_DIR"

    local repos
    repos=$(get_repos)
    local total
    total=$(echo "$repos" | wc -l | tr -d ' ')

    report "Processing ${total} repos..."
    report "==============================="
    report ""

    local idx=0
    echo "$repos" | while read -r repo; do
        idx=$((idx + 1))
        report "[${idx}/${total}] ${repo}"

        local repo_dir="${WORK_DIR}/${repo}"

        # Clone or reuse
        if [[ ! -d "$repo_dir" ]] && ! $SKIP_CLONE; then
            git clone --depth 1 "https://github.com/${ORG}/${repo}.git" "$repo_dir" 2>/dev/null
        elif [[ ! -d "$repo_dir" ]]; then
            report "  [ERROR] Repo dir not found and --skip-clone set"
            continue
        fi

        # Apply transformations
        replace_copyright_headers "$repo_dir"
        replace_reuse_toml "$repo_dir" "$repo"
        replace_contacts "$repo_dir"
        clean_contributing "$repo_dir"
        remove_sap_legal_links "$repo_dir"
        remove_inherited_files "$repo_dir"
        ensure_readme_footer "$repo_dir"
        flag_btp_links "$repo_dir" "$repo"

        # Verify
        if verify_clean "$repo_dir"; then
            report "  [VERIFY] Clean"
        else
            report "  [VERIFY] Residual references found (see above)"
        fi

        # Commit
        commit_and_push "$repo_dir" "$repo"
        report ""
    done

    report "==============================="
    report "Done. Report saved to: ${REPORT_FILE}"
}

main
