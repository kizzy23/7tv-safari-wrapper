# 7TV Safari

This workspace prepares 7TV's public WebExtension source for Safari using Apple's Safari WebExtension converter. The default build clones `SevenTV/Extension`, builds it locally, and converts the output into a personal-use Safari extension project.

Unofficial project. Not affiliated with, endorsed by, or supported by 7TV or SEVENTV SARL. 7TV source, packages, and assets are fetched at build time and remain subject to upstream licensing and distribution terms.

## Why this path

The current 7TV extension is not just a site userscript. It uses a generated extension manifest, a background service worker, extension storage, host permissions, web accessible resources, and content-script loading. A userscript would need to reimplement enough of that extension runtime to be brittle. Safari's native WebExtension bridge is the more viable personal-use path.

## Workflow

Default public-source build:

```sh
npm run rebuild:safari
```

This clones or updates `SevenTV/Extension`, builds the public-source extension locally, and converts it into `safari/stable/`.

Open the generated project:

```sh
open "safari/stable/SevenTV Safari/SevenTV Safari.xcodeproj"
```

Run the `SevenTV Safari` scheme in Xcode, then enable the extension in Safari Settings.

Public-source nightly/pre-release build:

```sh
npm run rebuild:safari:nightly
```

Chrome Web Store fallback build:

```sh
npm run rebuild:safari:webstore
```

The Chrome Web Store fallback downloads `lppmekppnliemjclknbagdhoocikieoi`, unpacks it under `build/chrome-webstore/`, removes Chrome-only package metadata, and converts it into `safari/next/`. Generated upstream, downloaded, and Safari project directories are intentionally ignored by git.

## Requirements

- Node.js and npm
- Full Xcode, not only the Xcode Command Line Tools
- Safari with unsigned extensions enabled for local personal use

This wrapper runs Yarn 1 through `npm exec`, so it does not require a global Yarn install.

If the converter is missing after installing Xcode, select Xcode's developer directory:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

## Runtime notes

Xcode may print WebKit sandbox messages about `linkd`, pasteboard, LaunchServices, RunningBoard, or AppIntents when running the generated host app. These are expected from Safari/WebKit helper processes in a local unsigned debug build and do not automatically indicate that the extension failed.

The converter currently warns that Safari does not support the `management`, `default_area`, and `open_in_tab` manifest keys. The extension can still run, but features depending on unsupported Safari APIs or Twitch player internals may need targeted compatibility work.

If the toolbar popup differs from the Chrome Web Store package, that is upstream behavior from the public source build. Use `npm run rebuild:safari:webstore` as a comparison build.

If Safari shows duplicate local 7TV entries after renaming or regenerating the host app, clear the old Xcode DerivedData build and reopen Safari:

```sh
rm -rf ~/Library/Developer/Xcode/DerivedData/7TV_Safari-*
```

## Configuration

Optional environment variables:

- `UPSTREAM_REF`: upstream branch, tag, or ref, defaults to `nightly-release`
- `BUILD_MODE`: 7TV build mode, defaults to `prod`
- `APP_NAME`: generated Safari app name, defaults to `SevenTV Safari`
- `BUNDLE_IDENTIFIER`: generated app bundle identifier, defaults to `dev.local.seventv.safari`
- `SAFARI_DIR`: generated Xcode project directory, defaults to `safari`
- `EXTENSION_ID`: Chrome Web Store extension id for fallback `npm run fetch:webstore`, defaults to `lppmekppnliemjclknbagdhoocikieoi`

## Variants

- Default public-source stable-style: `npm run rebuild:safari`, app name `SevenTV Safari`, output `safari/stable/`
- Public-source nightly: `npm run rebuild:safari:nightly`, app name `SevenTV Safari Nightly`, output `safari/nightly/`
- Chrome Web Store fallback: `npm run rebuild:safari:webstore`, app name `SevenTV Safari Next`, output `safari/next/`

## Publishing

For GitHub publishing guidance, see `docs/github.md`.

## Current upstream status

For the latest verified Chrome Web Store and public-source upstream status, see `docs/status.md`.

## Performance troubleshooting

For isolation steps when Safari or the extension feels slow, see `docs/performance.md`.
