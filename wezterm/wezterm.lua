local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.audible_bell = "Disabled"

config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Medium' })

config.initial_cols = 120
config.initial_rows = 28
config.font_size = 10

config.use_fancy_tab_bar = false

config.enable_scroll_bar = false
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

config.leader = { key="a", mods="CTRL", timeout_milliseconds=1000 }

local act = wezterm.action
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)
config.keys = {
  {
    key = '|',
    mods = 'SHIFT|LEADER',
    action = act.SplitHorizontal{domain="CurrentPaneDomain"},
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical{domain="CurrentPaneDomain"},
  },
  {
    key = 'h',
    mods = 'SHIFT|CTRL',
    action = act.ActivateCopyMode,
  },
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  {
    key = 'b',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}
      overrides.enable_tab_bar = not overrides.enable_tab_bar
      window:set_config_overrides(overrides)
    end),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivateLastTab,
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  { key = 'p', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
  { key = 'n', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  -- Switch to the default workspace
  {
    key = 'y',
    mods = 'CTRL|SHIFT',
    action = act.SwitchToWorkspace {
      name = 'default',
    },
  },
  -- Create a new workspace with a random name and switch to it
  { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
  -- Show the launcher in fuzzy selection mode and have it list all workspaces
  -- and allow activating one.
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
    -- Prompt for a name to use for a new workspace and switch to it.
  {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {key = "S", mods = "LEADER", action = act{EmitEvent = "save_session"}},
  {key = "L", mods = "LEADER", action = act{EmitEvent = "load_session"}},
  {key = "R", mods = "LEADER", action = act{EmitEvent = "restore_session"}},
  {key = "x", mods = "LEADER", action = act.CloseCurrentTab { confirm = true }},
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
-- config.default_prog = { 'powershell.exe' }
config.default_prog = { 'pwsh.exe' }
end

return config
