local M = {}

local behavior_handler = function (behavior)
   if behavior.close_on_exit then
      vim.cmd("au TermClose * lua vim.api.nvim_input('<CR>')")
   end
   vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]
end

local keymaps_handler = function (keymaps, window_opts)
   local get_dims = function ()
      local width_const = math.floor(vim.api.nvim_win_get_width(0)*window_opts["vsplit_width"])
      local height_const = math.floor(vim.api.nvim_win_get_height(0)*window_opts["split_height"])
      return {horizontal = height_const, vertical =  width_const}
   end
   local dims = get_dims()
   local function set_keymap(direction, hotkey)
      vim.keymap.set("n", hotkey, function()
         require("chadterm.terminal").new_or_toggle(direction, dims)
      end, {silent=true, noremap=true})
      vim.keymap.set("t", hotkey,
      function()
         require("chadterm.terminal").new_or_toggle(direction, dims)
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
