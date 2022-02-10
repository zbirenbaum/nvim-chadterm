local M = {}

local behavior_handler = function (behavior)
   if behavior.close_on_exit then
      vim.cmd("au TermClose * lua vim.api.nvim_input('<CR>')")
   end
   vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
end

local function legacy_make_cmd(direction, window_opts)
   local function table_to_string()
      string = "{"
      for k,v in pairs(window_opts) do
         string = string .. k .. "=" .. tostring(v) .. ","
      end
      string = string .. "}"
      return(string)
   end
   local on_hotkey = "<CMD>lua require('chadterm.terminal').new_or_toggle('"
   on_hotkey = on_hotkey .. direction .. "'," .. table_to_string() .. ")<CR>"
   return on_hotkey
end

local keymaps_handler = function (keymaps, window_opts)
   local function set_keymap(direction, hotkey)
      local is_legacy = not vim.fn.has(".7")
      if is_legacy then
         local cmd_str = legacy_make_cmd(direction, window_opts)
         vim.api.nvim_set_keymap("n", hotkey, cmd_str, {silent=true, noremap=true})
         vim.api.nvim_set_keymap("t", hotkey, cmd_str, {silent=true, noremap=true})
      else
         vim.keymap.set("n", hotkey, function()
            require("chadterm.terminal").new_or_toggle(direction, window_opts)
         end, {silent=true, noremap=true})
         vim.keymap.set("t", hotkey,
         function()
            require("chadterm.terminal").new_or_toggle(direction, window_opts)
         end, {silent=true, noremap=true})
      end
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
