# Performance Checks

Use this checklist to determine whether slowdown is caused by 7TV Safari, Safari/WebKit, or the whole system.

## Quick isolation

1. Quit the generated `SevenTV Safari` host app.
2. Disable only the 7TV Safari extension in Safari Settings.
3. Test the same Twitch page for 5 minutes.
4. Re-enable 7TV Safari and retest the same stream, chat speed, and browser tabs.
5. Compare against Brave with the official 7TV extension on the same stream.

If performance only drops with the Safari extension enabled, treat it as a Safari/WebExtension compatibility issue. If it remains bad with the extension disabled, check system load, Safari, Twitch, and other extensions.

## macOS checks

Run these while the issue is happening:

```sh
top -o cpu
```

```sh
ps aux | egrep 'Safari|WebKit|SevenTV|Xcode' | sort -nrk 3 | head -20
```

In Activity Monitor, also check:

- CPU: `Safari Web Content`, `Safari Networking`, `SevenTV Safari`, and `com.apple.WebKit.GPU`
- Memory: whether Safari tabs or WebKit processes keep growing over time
- Energy: whether the high impact remains after disabling the extension

## 7TV settings to test

Temporarily disable high-cost features one at a time:

- Animated emotes
- Paints/cosmetics
- Chat badges and avatars
- Player modifications
- Audio compressor
- Sidebar previews

If one setting removes the slowdown, keep it disabled in Safari and compare the same setting in Brave. That distinguishes an upstream 7TV cost from a Safari-specific cost.
