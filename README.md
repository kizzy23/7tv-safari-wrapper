# 7TV Safari

This workspace builds the public [SevenTV/Extension](https://github.com/SevenTV/Extension) WebExtension and prepares it for Safari using Apple's Safari WebExtension converter.

Unofficial project. Not affiliated with, endorsed by, or supported by 7TV or SEVENTV SARL. 7TV source and assets are fetched from the public upstream repository at build time and remain subject to the upstream license.

## Why this path

The current 7TV extension is not just a site userscript. It uses a generated extension manifest, a background service worker, extension storage, host permissions, web accessible resources, and content-script loading. A userscript would need to reimplement enough of that extension runtime to be brittle. Safari's native WebExtension bridge is the more viable personal-use path.

## Workflow

Nightly/pre-release build:

```sh
npm run rebuild:safari:nightly
```

Stable build:

```sh
npm run rebuild:safari:stable
```

The upstream repo is cloned into `upstream/Extension`, built into `upstream/Extension/dist`, and converted into an Xcode project under `safari/`. The nightly build tracks SevenTV's `nightly-release` pre-release tag. The stable-style build tracks SevenTV's public `master` branch because the numbered stable tags in the public repo can lag behind Chrome Web Store releases. Generated upstream and Safari project directories are intentionally ignored by git.

After conversion, open the generated nightly project:

```sh
open "safari/nightly/SevenTV Safari Nightly/SevenTV Safari Nightly.xcodeproj"
```

Run the `SevenTV Safari Nightly` scheme in Xcode, then enable the extension in Safari Settings. The stable project is generated under `safari/stable/`.

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

The toolbar popup currently shows 7TV's upstream "Coming Soon" placeholder after permissions are granted. This is upstream behavior, not a Safari conversion bug.

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

## Variants

- Stable: `npm run rebuild:safari:stable`, app name `SevenTV Safari`, output `safari/stable/`
- Nightly: `npm run rebuild:safari:nightly`, app name `SevenTV Safari Nightly`, output `safari/nightly/`

## Publishing

For GitHub publishing guidance, see `docs/github.md`.
