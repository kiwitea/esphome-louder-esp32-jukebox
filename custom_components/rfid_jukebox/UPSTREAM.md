# Upstream tracking

This integration is vendored from
[XtracT/rfid_jukebox](https://github.com/XtracT/rfid_jukebox), from
`custom_components/rfid_jukebox/`. The vendored baseline is commit
[`8c1759d4fdb4cc469006f5364a16f1865adce516`](https://github.com/XtracT/rfid_jukebox/commit/8c1759d4fdb4cc469006f5364a16f1865adce516).
Only the integration directory is included; the upstream firmware is not.

Local changes add the `pause_on_tag_removal` option and optional ESPHome RFID
feedback action. The pause option defaults to `true` to preserve upstream
behavior. Set it to `false` to leave playback running when a tag is removed.
The feedback action asks the ESPHome device to play its locally stored success
or unknown-card tone.

To review upstream changes since the vendored baseline:

```sh
git remote add rfid-jukebox-upstream https://github.com/XtracT/rfid_jukebox.git
git fetch rfid-jukebox-upstream main
git diff 8c1759d4fdb4cc469006f5364a16f1865adce516 rfid-jukebox-upstream/main -- custom_components/rfid_jukebox
```

Skip the `git remote add` command if that remote is already configured.

To compare this local integration with the latest upstream version:

```sh
git diff rfid-jukebox-upstream/main -- custom_components/rfid_jukebox
```

Review upstream changes before syncing them so the local option and behavior
remain intact.
