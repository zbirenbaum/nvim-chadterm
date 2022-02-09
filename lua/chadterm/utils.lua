local M = {}

local behavior_handler = function (behavior)
   if behavior.close_on_exit then
      vim.cmd("au TermClose * lua vim.api.nvim_input('<CR>')")
   end
   vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
end

local keymaps_handler = function (keymaps, window_opts)
   local function set_keymap(direction, hotkey)
      vim.keymap.set("n", hotkey, function()
         require("chadterm.terminal").new_or_toggle(direction, window_opts)
      end, {silent=true, noremap=true})
      vim.keymap.set("t", hotkey,
      function()
         require("chadterm.terminal").new_or_toggle(direction, window_opts)
      end, {silent=true, noremap=true})
   end
   for direction, hotkey in pairs(keymaps) do
      set_keymap(direction, hotkey)
   end
end

M.config_handler = function (config)
   keymaps_handler(config["keymaps"], config["window"])
   behavior_handler(config["behavior"])
end

return M
