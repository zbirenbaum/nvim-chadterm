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

local behavior_handler = function (behavior)
   if behavior.close_on_exit then
      vim.cmd("au TermClose * lua vim.api.nvim_input('<CR>')")
   end
end

local window_handler = function (window)
   local split_percent_calc = function (width,height)
      local width_const = math.floor(vim.api.nvim_win_get_width(0)*width)
      local height_const = math.floor(vim.api.nvim_win_get_height(0)*height)
      return width_const, height_const
   end

   local width, height = split_percent_calc(
      window["vsplit_width"],
      window["split_height"]
   )

   local cmds = {
     horizontal = {
       existing = "rightbelow vsplit",
       new = "botright " .. tostring(height) .. "split",
       resize = "resize",
     },
     vertical = {
       existing = "rightbelow split",
       new = "botright " .. tostring(width) .. "vsplit",
       resize = "vertical resize",
     },
   }
   return cmds
end

local config_handler = function (config)
   keymaps_handler(config["keymaps"])
   behavior_handler(config["behavior"])
   M.get_cmds = function ()
      return window_handler(config["window"])
   end
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
      window = {
         vsplit_width = .3,
         split_height = .3,
      },
   }
   if user_config ~= nil and not vim.tbl_isempty(user_config) then
      config = vim.tbl_deep_extend(config, user_config)
   end
   config_handler(config)
end

return M
