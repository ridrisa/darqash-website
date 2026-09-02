# Dar Qash — دار قاش

Official website. Static, single page, Arabic-first with a full English mirror.
Hosted on GitHub Pages; domain and email at GoDaddy.

## Deploy / update
The site is served straight from the `main` branch. Any change pushed to `main`
is live within a minute or two.

First-time setup: run `./deploy.sh` (see the instructions delivered with this repo).

## Structure
- `index.html` — the entire site (HTML, CSS, JS)
- `images/` — optimised photography, textures, logo (SVG + PNG), favicon
- `CNAME` — custom domain for GitHub Pages
- `robots.txt`, `sitemap.xml` — search-engine files

## Editing copy
All text lives in `index.html`. Every string appears twice, in
`<span class="en-only">` and `<span class="ar-only">` — edit both.
