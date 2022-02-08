local M = {}

local set_keymaps = function (direction, hotkey)
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

local set_config_keymaps = function (keymaps)
   for direction, hotkey in pairs(keymaps) do
      set_keymaps(direction, hotkey)
   end
end

M.setup = function (user_config)
   local config = {
      keymaps = {
         horizontal = "<leader>x",
         vertical = "<leader>v",
         float = "<A-i>",
      },
   }
   if user_config ~= nil and not vim.tbl_isempty(user_config) then
      config = vim.tbl_deep_extend(config, user_config)
   end
   set_config_keymaps(config["keymaps"])
end

return M
