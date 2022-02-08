local M = {}

local keymaps_handler = function (keymaps)
   local function set_keymap(direction, hotkey)
      vim.keymap.set("n", hotkey,
         function()
            require("chadterm.terminal").new_or_toggle(direction)
         end, {silent=true, noremap=true
      })
      vim.keymap.set("t", hotkey,
         function()
            require("chadterm.terminal").new_or_toggle(direction)
         end, {silent=true, noremap=true
      })
   end
   for direction, hotkey in pairs(keymaps) do
      set_keymap(direction, hotkey)
   end
end

local behaviour_handler = function (behavior)
   if behavior.close_on_exit then
      vim.cmd("au TermClose * feedkeys('<CR>')")
   end
end

local config_handler = function (config)
   keymaps_handler(config["keymaps"])
   behaviour_handler(config["behaviour"])
end

M.setup = function (user_config)
   local config = {
      keymaps = {
         horizontal = "<leader>x",
         vertical = "<leader>v",
         float = "<A-i>",
      },
      behavior = {
         close_on_exit = true,
      },
   }
   if user_config ~= nil and not vim.tbl_isempty(user_config) then
      config = vim.tbl_deep_extend(config, user_config)
   end
   config_handler(config)
end

return M
