# Upstream Status

Last checked: 2026-05-29

## Recommended Chrome Web Store package

- Extension ID: `lppmekppnliemjclknbagdhoocikieoi`
- Current version: `1.0.30`
- Chrome Web Store updated date: 2026-05-25
- Local Safari wrapper rebuild: verified with `npm run rebuild:safari`
- Xcode Debug build: verified with `xcodebuild`

This is the default source used by `npm run rebuild:safari`.

## Public SevenTV GitHub source

- Repository: `SevenTV/Extension`
- `master`: `e835cd0ba1144d9448a1c8e2cbb271eca3cd89c2`
- `nightly-release`: `e835cd0ba1144d9448a1c8e2cbb271eca3cd89c2`
- `package.json` version: `3.1.22`
- Latest normal release tag observed: `v3.1.6`

The public-source variants remain available through `npm run rebuild:safari:stable` and `npm run rebuild:safari:nightly`, but the Chrome Web Store package is currently newer.
