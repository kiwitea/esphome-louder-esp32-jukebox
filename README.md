# Kids Jukebox

ESPHome firmware for a Sonocotta Louder-ESP32-S3 with the Owlbox-style PN532
reader and five-button controls. Sonocotta's functional packages are imported
remotely at a pinned upstream commit; device-specific logic is imported from
[jukebox.yaml](./jukebox.yaml) on this repository's `main` branch.

## Configuration

1. Copy `secrets.yaml.example` to `secrets.yaml`, then set the Wi-Fi credentials
   and the API encryption key. Use the key already associated with this device
   in Home Assistant; changing it will disconnect the existing integration.
2. Set `ma_entity` in [kids-jukebox.yaml](./kids-jukebox.yaml) to the actual
   Music Assistant player entity ID.
3. Validate with `esphome config kids-jukebox.factory.yaml`, then build and
   flash with `esphome run kids-jukebox.factory.yaml`. The first flash should be
   over USB.

This project does not publish precompiled firmware: each device needs a build
with its own Wi-Fi credentials and API encryption key. GitHub Actions compiles
the configuration on pushes and pull requests using example secrets, and the
release workflow repeats that build before publishing a release. CI verifies
that the project compiles; it does not produce or distribute firmware for users.

The Sonocotta packages are pinned to commit
`98d19a08d9b753ed7d14f2a30c799d40e3464942`. To update upstream deliberately,
change the `ref` in [kids-jukebox.yaml](./kids-jukebox.yaml). This imports
Sonocotta's `media-player-no-light.yaml` instead of its normal light-enabled
media player, and omits the RGB LED package because GPIO21 is the back button.
The local configuration sets the Louder board's base options and overrides
TAS5805M gain and volume limits for this 5 V setup.

The device-specific package uses `ref: main`, so ESPHome fetches its latest
version from this repository's `main` branch when resolving packages. Pin it to
a commit hash instead for reproducible builds; updating that hash is a manual
change.

The PN532 must be in SPI mode (switch 1 OFF, switch 2 ON). Its SPI pins are
GPIO12/13/11 with chip select on GPIO10. Buttons connect their GPIO pin to
GND: volume up GPIO5, volume down GPIO6, play/pause GPIO39, back GPIO21, and
forward GPIO40.

## Home Assistant and Music Assistant

Add this repository to HACS as a custom integration repository and install the
RFID Jukebox integration from it. Select the `RFID Jukebox Tag` text sensor and
the Music Assistant player, then map scanned UIDs to playlists or folders in
the integration's `rfid_mappings.yaml`.

The firmware includes short success and unknown-card tones as on-device audio
files. To enable them, update the firmware and set the integration's **ESPHome
feedback action** option to `esphome.kids_jukebox_rfid_feedback` (replace
`kids_jukebox` with the ESPHome node name if different). The tones play locally
on the jukebox; audio is not streamed from Home Assistant. Leave the option
empty to disable feedback tones.

The firmware publishes `Unknown` when a tag is removed, as required for
re-scanning the same tag. In the integration's options, disable **Pause
playback when tag is removed** to keep playback going; this also makes scanning
the same tag again restart playback. Back and forward controls are not gated on
a tag being present.