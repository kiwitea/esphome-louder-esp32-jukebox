# Kids Jukebox

ESPHome firmware for a Sonocotta Louder-ESP32-S3 with an Owlbox-style PN532
reader and five-button controls.

## Build your own firmware

There is no precompiled firmware download. Each device needs its own Wi-Fi
credentials and ESPHome API encryption key.

1. Follow the [project setup instructions](https://github.com/kiwitea/esphome-louder-esp32-jukebox#configuration).
2. Build and flash `kids-jukebox.factory.yaml` with ESPHome. The first flash
   should be over USB.

The repository's CI compiles the configuration on pushes and pull requests.
