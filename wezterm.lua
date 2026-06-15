local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Solarized Dark (Gogh)'

config.colors = {
  cursor_bg = '#2aa198',  -- Solarized cyan
  cursor_border = '#2aa198',
  cursor_fg = '#fdf6e3',
}

config.default_cursor_style = 'SteadyBlock'

return config
