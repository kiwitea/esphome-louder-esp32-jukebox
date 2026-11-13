# Kids Jukebox (Louder-ESP32-S3 + Home Assistant)

Nov 1, 2026 · @Malte

## Status and decisions

Replacing the Raspberry Pi Phoniebox with a Louder-ESP32-S3 running ESPHome, controlled by Home Assistant and Music Assistant, because the Pi's Spotify (librespot) setup kept breaking.

Decisions so far:

- Platform: Louder-ESP32-S3 (TAS5805M amplifier) with the Owlbox ESPHome firmware and Home Assistant integration.
- Home Assistant host: existing. Provides ESPHome, Music Assistant and the Marketplace integration.
- RFID: PN532 over SPI with new 13.56 MHz tags. The old 125 kHz EM4100 USB reader cannot be reused.
- Speakers: two Visaton FRS 7 (8 Ω, 6.5 cm) behind the two 6 × 6 cm front windows of the existing wooden box, 25 × 15 × 15 cm.
- Controls: keep the five existing buttons (back, forward, play/pause, volume up, volume down); no rotary encoder.
- Power: power bank at 5 V.
- Display: not now, perhaps later.
- Music source: Spotify through Music Assistant (Spotify Premium needed).
- Known trade-off: the box needs Home Assistant and Music Assistant running to play anything.
- Scanning: cards are tapped on a reader on the side of the box, and playback must keep going after the card is removed (conflicts with current Owlbox firmware; hence, requires customization)

## Hardware list

| Item | Qty | Status | Source | Price | Notes |
| --- | --- | --- | --- | --- | --- |
| Louder-ESP32-S3 Rev K2 (TAS5805M) | 1 | Have | Sonocotta | about $24 list price | - |
| PN532 NFC module V3, kit with S50 card and key tag | 1 | Have | Tinytronics | €6.00 incl. BTW | Must be set to SPI: DIP SW1 OFF, SW2 ON. Solder pin headers. Alternative: Kiwi Electronics, €8.99 excl. BTW. |
| Visaton FRS 7, 8 Ω (2.5" full-range, 6.5 cm) | 2 | Have | Bax Music | €11.70 each incl. BTW | 66.5 mm square frame, 32 mm deep; sits behind the 60 mm window. Ratings: (8 W RMS, about 88 dB). On a 5 V supply an 8 Ω speaker gets about half the power of a 4 Ω one, roughly 3 dB lower maximum volume. |
| NFC cards, 13.56 MHz (NTAG213 or 215, credit-card size) | 30 | have | Amazon.nl (30-card pack) | about €10 per 30 (reported, not checked) | Cards are scanned on the side-mounted reader and stack easily. Check the listing says NTAG213 or NTAG215 and 13.56 MHz. Any ISO 14443A card should work, since only the UID is read. Fallback: Kiwi Electronics ADA-4034 cards, €2.75 each excl. BTW at 10+. Old 125 kHz cards will not work. |
| Push buttons (back, forward, play/pause, vol up, vol down) | 5 | Have | From the Phoniebox | n/a | Wired to GND plus one GPIO each. |
| Power bank Intenso Powerbank XS10000 – 10.000 mAh&#32; | 1 | Have | n/a | n/a | Needs 5 V at 3 A and must not switch off at low load. Not yet checked. |
| Cable USB-A to bare wire | 1 | Have | n/a | n/a | From the power bank's USB-A port to the board's screw terminals. Can be made by cutting an old USB-A cable: red is +5 V, black is GND (check with a multimeter), and insulate the data wires. |
| Latching power switch, 16 mm panel hole, 3-6 V LED | 1 | Have | Tinytronics | €3.50 incl. BTW | Tinytronics 16 mm metal push button, raised, push on / push off, with a 3 to 6 V LED (built-in resistor). Rated 3 A at up to 24 V DC; 2.8 mm spade terminals. Needs a 16 mm hole (confirm on the product page). Wire the switch contacts in the +5 V line and the LED to the switched 5 V and GND. |
| Jumper wires, pin headers, speaker wire (0.5 mm², about 1 m) | 1 set | Have | n/a | n/a | Per the Owlbox manual. |
| Wooden box, 25 × 15 × 15 cm | 1 | Have | Existing | n/a | Must be airtight; two 6 × 6 cm front windows with 6 mm cross-bars, wood 5 mm thick. |
| OLED display (optional) | 1 | Optional | Sonocotta | not checked | Sonocotta SSH1106 30-pin OLED module, $5, ships from Poland: SH1106 128 × 64 white, SPI, 3.3 V, 30-pin 0.5 mm FPC. Generic 4-pin or 7-pin modules will not plug in. A display 20 to 30 cm from the board needs a 30-pin 0.5 mm FFC extension and a way to join it to the display's flex tail; not settled, and the contact side must match. |

## 3D printing

Parts to be printed. Nothing is designed yet. Known measurements: front windows 60 × 60 mm with 6 mm cross-bars, wood 5 mm thick, box 25 × 15 × 15 cm. Check everything against the real parts before printing.

| Part | Qty | Status | Requirements | Notes |
| --- | --- | --- | --- | --- |
| Speaker grill and holder | 2 | To design | Plug fits the 60 × 60 mm window (tune the tolerance, start around 0.2 mm per side) with a flange against the inside face of the wood. Mounted from the inside; its back cups the speaker. Open grill pattern in front that clears the cone and, if they are fixed, the cross-bars. | Speaker: Visaton FRS 7, 66.5 mm square frame, 30 to 39 mm deep. Get the mounting-hole positions from the Visaton datasheet. Fix with screws or glue and seal the edge against air leaks (foam or gasket). |
| Louder-ESP32 housing | 1 | To design or reuse | Board is Raspberry Pi 4 sized, so any existing Pi4 case fits. Needs access to the VDD screw terminal and reset button, the speaker terminals, all GPIO pins, and the OLED connector if used. | Community cases exist (see Links); reuse or remix one after checking its license. |

## Links and references

Prices and stock were seen on 1 November 2026 and may have changed.

Project and firmware:

- [Owlbox repo (ESPHome YAML, HA integration)](https://github.com/XtracT/rfid_jukebox)
- [Owlbox hardware manual](https://github.com/XtracT/rfid_jukebox/blob/main/docs/manual.md)
- [Owlbox on MakerWorld (3D-printed case, not used here)](https://www.makerworld.com/en/models/1914879)
- [Music Assistant](https://music-assistant.io/)
- [ESPHome PN532 component](https://new.esphome.io/components/binary_sensor/pn532/)
- [KidJuke: ESPHome plus a Home Assistant blueprint for scanned cards (possible fallback, not checked against this hardware)](https://community.home-assistant.io/t/kidjuke-the-alternative-to-faba-toniebox-yoto-in-home-assistant/1025623)

Board:

- [Louder-ESP32 product page (Sonocotta)](https://sonocotta.com/louder-esp32/)
- [Louder-ESP32 pinout (Tindie)](https://www.tindie.com/products/sonocotta/louder-esp32/)
- [esp32-audio-dock repo](https://github.com/sonocotta/esp32-audio-dock)
- [Sonocotta ESPHome configs and packages](https://github.com/sonocotta/esp32-audio-dock/blob/main/firmware/esphome/README.md)

Peripheral hardware:

- [Tinytronics: PN532 kit with S50 card and key tag](https://www.tinytronics.nl/index.php?route=product/product&product_id=1324)
  - [PN532 Datasheet](https://www.nxp.com/docs/en/nxp/data-sheets/PN532_C1.pdf)
- [Tinytronics: Metal Push Button 16mm - Raised - On-Off - with 3-6V Green LED](https://www.tinytronics.nl/index.php?route=product/product&product_id=3801)


3D printing:

- [Printables: Louder ESP32 s3 player/amplifier case](https://www.printables.com/model/1058552-louder-esp32-s3-playeramplifier-case)
- [Thangs: Louder ESP32 s3 Ethernet case (remix)](https://thangs.com/m/1250845)
- [Sonocotta: Raspberry Pi 4 compatible case for ESP32 Audio boards](https://lectronz.com/products/transparent-raspberry-pi-4-compatible-case)

Previous setup:

- [Phoniebox](https://phoniebox.de/)

Software:

- [Spotify Develop Dashboard (API Keys)](https://developer.spotify.com/dashboard)

## Hardware configuration

The PN532 uses the SPI pins on the board's Ethernet header, and four of the five buttons take over GPIOs the Owlbox firmware uses for its encoder and buttons (forward is on a mic header pin). Items marked verify need checking on the board.

| Function | GPIO | Location | Status |
| --- | --- | --- | --- |
| PN532 SPI CLK / MISO / MOSI / CS | 12 / 13 / 11 / 10 | W5500 (Ethernet) header | Owlbox YAML; pin labels confirmed on Rev K2 |
| Volume up | 5 | Header pin labeled RST | Owlbox encoder pin A, repurposed |
| Volume down | 6 | Header pin labeled INT | Owlbox encoder pin B, repurposed |
| Play/pause | 39 | Mic header, SD pin labeled 39 (shared by the L and R mic headers) | Confirmed on Rev K2 |
| Back | 21 | RGB out header (pins labeled 21, GND, 3V3) | Owlbox YAML; confirmed by the board label |
| Forward | 40 | Mic header, WS pin labeled 40 | Moved from GPIO7 (IR in header); confirmed on Rev K2 |
| I2S audio CLK / WS / DATA | 14 / 15 / 16 | Onboard | Taken |
| TAS5805M I2C SDA / SCL, PWDN | 8 / 9 / 17 | Onboard | Taken |
| TAS5805M FAULT | 18 | Onboard | Taken |
| PSRAM | 35, 36, 37 | Onboard | Reserved |
| Mic headers L and R: WS / CLK (SD is 39 above) | 40 / 41 | Two 6-pin headers (GND, LR, VDD, WS, SD, CLK), same pins on both | Confirmed on Rev K2; 40 used for forward, 41 free |
| UART | 43 / 44 | UART header (GND, 43, 44) | Confirmed on Rev K2; leave free (serial logging) |
| IR in | 7 | IR in header | Confirmed on Rev K2; not used (Owlbox YAML had forward here) |

Wiring notes:

- PN532: DIP switches to SPI (SW1 OFF, SW2 ON), pin headers soldered, 3.3 V and GND from the board, SPI lines to the Ethernet header. Do not fit an Ethernet module.
- Buttons: each between its GPIO and GND; the firmware enables the internal pull-ups.
- Speakers: two 8 Ω Visaton FRS 7 on the speaker terminals, held by the printed grill holders behind the front windows. Seal the box.
- Power: 5 V into the VIN screw terminals. The manual asks for 5 to 6 V at 3 A or more; Sonocotta lists 5 to 28 V input. Use one power input at a time. First test: power bank to the USB-C port with a plain cable, no switch.
- Final power wiring with the on/off button: a cut USB-A cable on the power bank's A port (bare USB-C pigtails often lack the resistors a power bank needs; general knowledge, not from the docs). Red goes to the button's C contact, its NO contact to the +5 V (VIN) screw terminal, black to the GND screw terminal. The button's + and - pins are its LED: + goes to the same point as the VIN wire (the NO side), - to GND. NC stays unconnected. Its 3 to 6 V LED has a built-in resistor and no polarity.
- Tags: no magnets near the reader; the Owlbox author says they interfere.
- Display (optional): solderless 30-pin FPC connector (0.5 mm pitch). It uses SPI: it shares CLK 12, MOSI 11 and MISO 13 with the PN532 and has its own CS 47, DC 38 and RST 48.

## Software configuration

ESPHome on the board reports the tag UID; the HACS RFID Jukebox integration in Home Assistant maps each UID to a Music Assistant playlist or folder.

How it runs:

1. A tag on the PN532 is published by ESPHome to the text sensor `RFID Jukebox Tag`.
2. The integration looks up the UID in `rfid_mappings.yaml` in the Home Assistant config folder.
3. It tells Music Assistant to play the mapped playlist or folder on the jukebox player.
4. In the stock Owlbox, removing the tag pauses. This build must keep playing instead (see Tag removal in the table below).

Home Assistant setup:

- [x] Install Music Assistant (add-on on Home Assistant OS, Docker otherwise) and add the Spotify provider
- [x] Install HACS
- [x] Add `https://github.com/XtracT/rfid_jukebox` as a custom HACS repository (category Integration), install, restart
- [x] Flash the firmware over USB, then adopt the device in ESPHome
- [ ] Add the RFID Jukebox integration: tag sensor, Music Assistant player, filesystem ID
- [ ] Scan tags and map each to a playlist or folder

Changes to the Owlbox `esphome/jukebox.yaml` (needs ESPHome 2025.8.0 or newer):

| Area | Change |
| --- | --- |
| Substitutions | Set `ma_entity` (file has the placeholder `media_player.owlbox-ma`). Set or remove the static IP (192.168.1.160 in the file). Add Wi-Fi secrets. |
| Encoder | Remove the `rotary_encoder` sensor and the `encoder_a_pin` / `encoder_b_pin` substitutions. |
| Volume buttons | Add volume up on GPIO5 and volume down on GPIO6 (snippet below). |
| Play/pause | Keep the "Encoder Button" block on GPIO39 and rename it. |
| Back and forward | Back stays on GPIO21. Forward moves from GPIO7 to GPIO40 (the btn\_next\_pin substitution). Remove the tag\_present check in both button blocks; the file only lets them act while a tag is on the reader, which never happens with scanned cards. |
| Volume limits | File sets DAC volume\_max -12 dB, volume\_min -60 dB, analog\_gain -9 dB, player volume\_max 80%, step 2%. Tune on the real speakers; analog gain should match the supply voltage. |
| Key typo | `clock fault:` is probably meant to be `clock_fault:`; the compiler will tell. |
| Flash size | The Owlbox file says flash\_size: 16MB, but the board is an N8R8: 8 MB flash and 8 MB PSRAM (Sonocotta). Set flash\_size: 8MB; the boot log confirms "SPI Flash Size: 8MB". |
| Boot sound | `tas5805m_boot_louder.flac` must sit next to the YAML; the DAC needs it to lock the clock. |
| Idle | The DAC powers down after 2 minutes idle or paused. |
| Display (optional) | Add Sonocotta's `oled.yaml` package once the module is chosen. |
| Tag removal | Confirmed in the integration's \_\_init\_\_.py: when the tag sensor goes to unknown, none or empty, it pauses a playing player. Keep the firmware as is: it publishes Unknown on removal, which is also what lets a repeat scan of the same card register. Patch the integration instead: in async\_tag\_changed\_handler, replace the final else branch (tag removed) with a log line. Fork the repo and add the fork as the HACS custom repository, since an edit in place is overwritten by updates. |
| OTA and API security | ESPHome 2026.10 warns about OTA passwords. Use an api: encryption: key plus ota: - platform: esphome with encryption: and no password. Keep the key Home Assistant already has for the device; a new key locks Home Assistant out. The Owlbox YAML has neither, so add both when adopting it. |

Base config approach (decided 10 November): use Sonocotta's louder-esp32-s3-idf.yaml as the base instead of the older Owlbox file, keep its remote packages pinned to a tag or commit that is bumped on purpose, and drop its light.yaml package because that claims GPIO21, the back button. Everything specific to this box goes in a local jukebox.yaml package: PN532, tag text sensor, five buttons and the Home Assistant actions. The table above lists changes relative to the Owlbox file; the amplifier, volume limits and boot sound now come from Sonocotta's packages instead.

Volume up button (untested draft; volume down is the same with GPIO6 and `media_player.volume_down`):

```yaml
binary_sensor:
  - platform: gpio
    name: "${friendly_name} Volume Up"
    pin:
      number: GPIO5
      mode: INPUT_PULLUP
      inverted: true
    filters:
      - delayed_on: 20ms
      - delayed_off: 20ms
    on_press:
      - if:
          condition:
            lambda: 'return !id(louder_mediaplayer).is_muted();'
          then:
            - media_player.volume_up:
                id: louder_mediaplayer
```

## Open questions and changelog

Check these when the board is at home, then update the hardware list and ask Claude to sync the configuration.

- [x] Board revision (silkscreen): K2
- [x] Where GPIO7 comes out on this revision (GPIO21 is the RGB out header, GPIO39 the mic header), and whether it is a 3-pin JST socket --> 07 is IR IN and is taken because IR sensor is mounted.
- [x] Flash size: confirmed 8 MB in the boot log
- [x] Music source: Spotify via Music Assistant (decided). Confirm the Spotify account is Premium
- [x] Home Assistant install type (OS or Container), which decides how Music Assistant is installed
- [x] Power bank: 5 V at 3 A, and does it stay on at low load
- [x] Mounting-hole positions of the Visaton FRS 7 (from the datasheet)
- [x] Does the PN532, mounted on the side of the box, need a printed bracket? --> No, we can use the 3mm mounting holes in the board to glue/screw it to the side of the box with nylon nuts and screws
- [x] Designs for the 3D-printed parts
- [x] Does the integration pause when a card is removed? Test by scanning and removing a card --> Yes. Customization required.
- [x] Does scanning the same card again restart playback, or is it ignored? --> Ignored. Customization needed.
- [x] Same card scanned while it is already playing: restart from the beginning (stock behavior) or keep playing? --> Restart from beginning
- [ ] Fork rfid\_jukebox, apply the removal patch, and install the fork through HACS
- [x] Decided: PN532 reader with new 13.56 MHz cards, tags or stickers; the old 125 kHz cards are retired

Changelog, newest first:

| Date | Change |
| --- | --- |
| 2026-11-13 | Added the ESPHome build using pinned Sonocotta packages and a local jukebox package; RGB light removed to free GPIO21 for the back button. |
| 2026-11-08 | Speakers changed to the 8 Ω Visaton FRS 7: cheaper and available, about 3 dB lower maximum volume on 5 V. |
| 2026-11-07 | Read the integration source: it pauses on unknown, none or empty. Plan changed to patching the integration and keeping the firmware as is. |
| 2026-11-07 | Cards are scanned on a side-mounted reader: playback must continue after removal, and back/forward must work without a card present. |
| 2026-11-07 | Power switch changed to a Tinytronics 16 mm on/off push button with a 3 to 6 V LED (the old 12 mm hole gets enlarged). |
| 2026-11-07 | GPIO map confirmed on Rev K2. GPIO7 is the IR in header, so forward moved to GPIO40 (mic header). |
| 2026-11-07 | Added a 12 mm latching power switch to the hardware list. GPIO21 (back button) is the RGB out header: pins 21, GND, 3V3. |
| 2026-11-07 | Board received (Rev K2). Speakers changed to Visaton FRS 7 (4 Ω) for the 6 × 6 cm windows; added the 3D printing table. |
| 2026-11-01 | Music source decided: Spotify through Music Assistant. |
| 2026-11-01 | Doc created from the planning chat: hardware list, GPIO map, YAML changes. |
