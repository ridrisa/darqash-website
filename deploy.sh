#!/usr/bin/env bash
# Dar Qash — one-time GitHub Pages deployment.
# Requirements: git and the GitHub CLI (https://cli.github.com). Run from inside this folder.
set -e
GH_USER="ridrisa"
REPO="darqash-website"

read -rp "Your domain (e.g. darqash.com, without www): " DOMAIN
DOMAIN="${DOMAIN#www.}"
[ -z "$DOMAIN" ] && { echo "Domain is required."; exit 1; }

echo "→ Writing domain into the site files"
sed -i.bak "s#https://darqash\.com/#https://www.${DOMAIN}/#g" index.html sitemap.xml robots.txt && rm -f index.html.bak sitemap.xml.bak robots.txt.bak
echo "www.${DOMAIN}" > CNAME

echo "→ Committing"
git add -A
git -c user.name="Dar Qash" -c user.email="deploy@${DOMAIN}" commit -qm "Set production domain to ${DOMAIN}" || true

echo "→ Signing in to GitHub (a browser window will open)"
gh auth status >/dev/null 2>&1 || gh auth login --web -h github.com -p https -s repo

echo "→ Creating the repository ${GH_USER}/${REPO} and pushing"
gh repo create "${GH_USER}/${REPO}" --public --source=. --remote=origin --push --description "Dar Qash — official website"

echo "→ Enabling GitHub Pages from the main branch with your domain"
gh api -X POST "repos/${GH_USER}/${REPO}/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
gh api -X PUT  "repos/${GH_USER}/${REPO}/pages" -f "cname=www.${DOMAIN}" -F "https_enforced=false" >/dev/null 2>&1 || true

cat <<MSG

✓ Repository: https://github.com/${GH_USER}/${REPO}
✓ Temporary URL (live in ~1 minute): https://${GH_USER}.github.io/${REPO}/

NOW ADD THESE RECORDS IN GODADDY  (My Products → ${DOMAIN} → DNS → Add)
  Type   Name   Value                     TTL
  A      @      185.199.108.153           1 hour
  A      @      185.199.109.153           1 hour
  A      @      185.199.110.153           1 hour
  A      @      185.199.111.153           1 hour
  CNAME  www    ${GH_USER}.github.io      1 hour
Delete only GoDaddy's default "Parked" A record and any existing "www" CNAME.
Do NOT touch MX, TXT, or autodiscover records — those are your email.

Then: GitHub → repository → Settings → Pages → wait for "DNS check successful"
→ tick "Enforce HTTPS". Your site is live at https://www.${DOMAIN}
MSG
