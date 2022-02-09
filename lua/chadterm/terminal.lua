local get_cmds = function(dims)
   local cmds = {
     horizontal = {
       existing = "rightbelow vsplit",
       new = "botright " .. dims["horizontal"] .. "split",
       resize = "resize",
     },
     vertical = {
       existing = "rightbelow split",
       new = "botright " .. dims["vertical"] .. "vsplit",
       resize = "vertical resize",
     },
   }
   return cmds
end

local M = {}

local chadterms = Globals.chadterms

function M.new_or_toggle (direction, dims)
   local function new_term(exists)
      local cmds = get_cmds(dims)
      print(vim.inspect(cmds))
      if not exists then
         vim.cmd(cmds[direction]["new"])
      else
         vim.cmd(cmds[direction]["existing"])
      end
      local wins = vim.api.nvim_list_wins()
      local term_id = wins[#wins]
      chadterms[direction][1] = term_id
      vim.api.nvim_set_current_win(term_id)
      vim.cmd("term")
      vim.api.nvim_input('i')
   end

   local function hide_term()
      local term_id = chadterms[direction][1]
      if term_id then
         vim.api.nvim_set_current_win(term_id)
         vim.cmd('hide')
      end
   end

   local function show_term()
      local term_id = nil
      local prev_wins = vim.api.nvim_list_wins()
      local new_wins = vim.api.nvim_list_wins()
      for _,v in ipairs(new_wins) do
         if not vim.tbl_contains(prev_wins, v) then
            term_id = v
            chadterms[direction][1] = term_id
         end
      end
      if term_id ~= nil then
         vim.api.nvim_set_current_win(term_id)
         vim.api.nvim_input('i')
      else
         new_term(direction)
      end
   end
   if (vim.tbl_isempty(chadterms[direction]) or not chadterms[direction][1]) then
      new_term()
   elseif not vim.tbl_contains(vim.api.nvim_list_wins(), chadterms[direction][1]) then
      show_term()
   else
      hide_term()
   end
end

return M
