local wezterm = require("wezterm")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup()

local function spread(template)
	return function(table)
		local result = {}
		for key, value in pairs(template) do
			result[key] = value
		end

		for key, value in pairs(table) do
			result[key] = value
		end
		return result
	end
end

local config = spread(wezterm.config_builder())({
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = true,
	use_fancy_tab_bar = true,
	font_size = 14.0,
	font = wezterm.font("FiraCode Nerd Font"),
	window_frame = {
		font = wezterm.font("FiraCode Nerd Font"),
		size = 13,
	},
	window_padding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},
	-- macos_window_background_blur = 40,
	-- macos_window_background_blur = 0,

	-- window_background_image_hsb = {
	-- 	brightness = 0.01,
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	-- window_background_opacity = 0.92,
	window_background_opacity = 0.95,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
})

tabline.apply_to_config(config)

return config
