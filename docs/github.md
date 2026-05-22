# Publishing to GitHub

This repository is intended to publish only the Safari packaging wrapper, not generated 7TV builds.

## What to commit

Commit these files:

- `.gitignore`
- `README.md`
- `package.json`
- `docs/github.md`
- `scripts/*.sh`

Do not commit these generated directories:

- `upstream/Extension/`
- `safari/`
- `build/`
- `node_modules/`

The generated `safari/` project contains copied 7TV extension resources. Keeping it out of GitHub avoids redistributing a built derivative and keeps this repo focused on personal-use build tooling.

The wrapper defaults to the recommended Chrome Web Store build, which downloads the current package at build time and generates `SevenTV Safari Next`. Public-source stable-style and nightly variants are still available for comparison.

## Optional GitHub nightly release

If you create GitHub releases for this wrapper, use a separate tag such as `nightly` or `nightly-YYYYMMDD` and check GitHub's **Set as a pre-release** option. Do not upload generated 7TV extension binaries unless you have reviewed upstream redistribution and trademark requirements.

## Suggested repository description

Unofficial personal-use Safari WebExtension packaging wrapper for 7TV.

## Suggested README disclaimer

Unofficial project. Not affiliated with, endorsed by, or supported by 7TV or SEVENTV SARL. 7TV source, packages, and assets are fetched at build time and remain subject to upstream licensing and distribution terms.

## First push

Create an empty GitHub repository, then run:

```sh
git add .gitignore README.md package.json docs/github.md scripts
git commit -m "Add Safari packaging wrapper"
git branch -M main
git remote add origin git@github.com:YOUR_USERNAME/7tv-safari.git
git push -u origin main
```

If you prefer HTTPS instead of SSH:

```sh
git remote add origin https://github.com/YOUR_USERNAME/7tv-safari.git
```
