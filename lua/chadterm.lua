local M = {}

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
      window = {
         vsplit_width = .3,
         split_height = .3,
      },
   }
   if user_config ~= nil and not vim.tbl_isempty(user_config) then
      config = vim.tbl_deep_extend(config, user_config)
   end
   require("chadterm.globals").init_globals()
   require("chadterm.utils").config_handler(config)
end

return M

