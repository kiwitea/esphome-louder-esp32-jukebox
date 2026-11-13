# Kids Jukebox

ESPHome firmware for a Sonocotta Louder-ESP32-S3 with the Owlbox-style PN532
reader and five-button controls. Sonocotta's functional packages are imported
remotely at a pinned upstream commit; device-specific logic is kept in
[jukebox.yaml](./jukebox.yaml).

## Configuration

1. Copy `secrets.yaml.example` to `secrets.yaml`, then set the Wi-Fi credentials
   and the API encryption key. Use the key already associated with this device
   in Home Assistant; changing it will disconnect the existing integration.
2. Set `ma_entity` in [kids-jukebox.yaml](./kids-jukebox.yaml) to the actual
   Music Assistant player entity ID.
3. Validate or build with `esphome config kids-jukebox.factory.yaml` or
   `esphome run kids-jukebox.factory.yaml`. The first flash should be over USB.

The Sonocotta packages are pinned to commit
`98d19a08d9b753ed7d14f2a30c799d40e3464942`. To update upstream deliberately,
change the `ref` in [kids-jukebox.yaml](./kids-jukebox.yaml). This imports
Sonocotta's `media-player-no-light.yaml` instead of its normal light-enabled
media player, and omits the RGB LED package because GPIO21 is the back button.
The local configuration sets the Louder board's base options and overrides
TAS5805M gain and volume limits for this 5 V setup.

The PN532 must be in SPI mode (switch 1 OFF, switch 2 ON). Its SPI pins are
GPIO12/13/11 with chip select on GPIO10. Buttons connect their GPIO pin to
GND: volume up GPIO5, volume down GPIO6, play/pause GPIO39, back GPIO21, and
forward GPIO40.

## Home Assistant and Music Assistant

Install the RFID Jukebox HACS integration, select the `RFID Jukebox Tag` text
sensor and the Music Assistant player, then map scanned UIDs to playlists or
folders in the integration's `rfid_mappings.yaml`.

The firmware publishes `Unknown` when a tag is removed, as required for
re-scanning the same tag. The stock RFID Jukebox integration pauses playback
on that state, so keeping playback going requires the planned change to
`async_tag_changed_handler` in a maintained fork of that integration. Back and
forward controls are not gated on a tag being present.