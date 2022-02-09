local M = {}

local init_globals = function()
   Globals = {
      chadterms = {
         horizontal = {},
         vertical = {}
      },
   }
end

M.setup = function (user_config)
   local config = {
      keymaps = {
         horizontal = "<leader>h",
         vertical = "<leader>v",
         float = "<A-i>",
      },
      behavior = {
         close_on_exit = true,
      },
      window = {
         vsplit_width = .5,
         split_height = .3,
      },
   }
   if user_config ~= nil and not vim.tbl_isempty(user_config) then
      config = vim.tbl_deep_extend(config, user_config)
   end
   init_globals()
   require("chadterm.utils").config_handler(config)
end

return M

