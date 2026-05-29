# 7TV Safari

This workspace prepares 7TV's WebExtension for Safari using Apple's Safari WebExtension converter. The default build uses the current recommended Chrome Web Store package, while public-source stable/nightly builds remain available as alternate variants.

Unofficial project. Not affiliated with, endorsed by, or supported by 7TV or SEVENTV SARL. 7TV source, packages, and assets are fetched at build time and remain subject to upstream licensing and distribution terms.

## Why this path

The current 7TV extension is not just a site userscript. It uses a generated extension manifest, a background service worker, extension storage, host permissions, web accessible resources, and content-script loading. A userscript would need to reimplement enough of that extension runtime to be brittle. Safari's native WebExtension bridge is the more viable personal-use path.

## Workflow

Default recommended build:

```sh
npm run rebuild:safari
```

This downloads the current Chrome Web Store package for `lppmekppnliemjclknbagdhoocikieoi`, unpacks it under `build/chrome-webstore/`, removes Chrome-only package metadata, and converts it into `safari/next/`.

Open the generated project:

```sh
open "safari/next/SevenTV Safari Next/SevenTV Safari Next.xcodeproj"
```

Run the `SevenTV Safari Next` scheme in Xcode, then enable the extension in Safari Settings.

Public-source nightly/pre-release build:

```sh
npm run rebuild:safari:nightly
```

Public-source stable-style build:

```sh
npm run rebuild:safari:stable
```

The public-source variants clone `upstream/Extension`, build into `upstream/Extension/dist`, and convert into `safari/stable/` or `safari/nightly/`. Generated upstream, downloaded, and Safari project directories are intentionally ignored by git.

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

The older public-source extension line may show 7TV's upstream "Coming Soon" toolbar popup after permissions are granted. The default Chrome Web Store package uses its own `popup.html`.

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
- `EXTENSION_ID`: Chrome Web Store extension id for `npm run fetch:webstore`, defaults to `lppmekppnliemjclknbagdhoocikieoi`

## Variants

- Default recommended Chrome Web Store: `npm run rebuild:safari`, app name `SevenTV Safari Next`, output `safari/next/`
- Public-source stable-style: `npm run rebuild:safari:stable`, app name `SevenTV Safari`, output `safari/stable/`
- Public-source nightly: `npm run rebuild:safari:nightly`, app name `SevenTV Safari Nightly`, output `safari/nightly/`

## Publishing

For GitHub publishing guidance, see `docs/github.md`.

## Current upstream status

For the latest verified Chrome Web Store and public-source upstream status, see `docs/status.md`.
