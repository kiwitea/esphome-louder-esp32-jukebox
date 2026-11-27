"""Config flow for RFID Jukebox."""
from typing import Any, Dict, Optional

import voluptuous as vol
from homeassistant import config_entries
from homeassistant.core import callback
from homeassistant.helpers import selector

from .const import (
    DOMAIN,
    CONF_TAG_SENSOR,
    CONF_MEDIA_PLAYER,
    CONF_MA_FILESYSTEM,
    CONF_FEEDBACK_ACTION,
    CONF_PAUSE_ON_TAG_REMOVAL,
    DEFAULT_PAUSE_ON_TAG_REMOVAL,
)


def _common_config_schema(config: Optional[Dict[str, Any]] = None) -> Dict[Any, Any]:
    """Return the fields shared by the config and options flows."""
    config = config or {}

    def field(
        key: str,
        *,
        optional: bool = False,
        default: Any = None,
    ) -> Any:
        marker = vol.Optional if optional else vol.Required
        if key in config:
            return marker(key, default=config[key])
        if default is not None:
            return marker(key, default=default)
        return marker(key)

    return {
        field(CONF_TAG_SENSOR): selector.EntitySelector(
            selector.EntitySelectorConfig(domain=["sensor", "input_text"]),
        ),
        field(CONF_MEDIA_PLAYER): selector.EntitySelector(
            selector.EntitySelectorConfig(domain="media_player"),
        ),
        field(CONF_MA_FILESYSTEM, optional=True): str,
        field(CONF_FEEDBACK_ACTION, optional=True): str,
        field(
            CONF_PAUSE_ON_TAG_REMOVAL,
            default=DEFAULT_PAUSE_ON_TAG_REMOVAL,
        ): selector.BooleanSelector(),
    }


class RFIDJukeboxConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    """Handle a config flow for RFID Jukebox."""

    VERSION = 1
    CONNECTION_CLASS = config_entries.CONN_CLASS_LOCAL_POLL

    async def async_step_user(self, user_input: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Handle the initial step."""
        if user_input is not None:
            return self.async_create_entry(title="RFID Jukebox", data=user_input)

        return self.async_show_form(
            step_id="user",
            data_schema=vol.Schema(_common_config_schema()),
        )

    @staticmethod
    @callback
    def async_get_options_flow(
        _config_entry: config_entries.ConfigEntry,
    ) -> config_entries.OptionsFlow:
        """Get the options flow for this handler."""
        return RFIDJukeboxOptionsFlowHandler()


class RFIDJukeboxOptionsFlowHandler(config_entries.OptionsFlow):
    """Handle an options flow for RFID Jukebox."""

    async def async_step_init(self, user_input: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Manage the options."""
        if user_input is not None:
            return self.async_create_entry(title="", data=user_input)

        config = {**self.config_entry.data, **self.config_entry.options}
        schema = _common_config_schema(config)

        return self.async_show_form(
            step_id="init",
            data_schema=vol.Schema(schema),
        )
