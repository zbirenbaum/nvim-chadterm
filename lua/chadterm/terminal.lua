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

local function on_action(chadterms)
   Globals.chadterms = chadterms
end

function M.new_or_toggle (direction, dims)
   local chadterms = Globals.chadterms
   print(vim.inspect(dims))
   local cmds = get_cmds(dims)
   local wins = vim.api.nvim_list_wins()
   local bufs = vim.api.nvim_list_bufs()

   local function new_term()
      vim.cmd(cmds[direction]["new"])
      local term_win_id = wins[#wins]
      local term_buf_id = bufs[#bufs]
      chadterms[direction][1] = { win = term_win_id, buf = term_buf_id }
      vim.api.nvim_set_current_win(term_win_id)
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
      local term_buf = chadterms[direction][1]["buf"]
      if vim.api.nvim_buf_is_valid(term_buf) then
         vim.cmd(cmds[direction]["new"])
         vim.api.nvim_set_current_win(wins[#wins])
         vim.api.nvim_win_set_buf(term_buf)
         chadterms[direction][1]["win"] = wins[#wins]
      else
         new_term()
      end
   end

   if vim.tbl_isempty(chadterms[direction]) then
      new_term()
   elseif not vim.tbl_contains(vim.api.nvim_list_wins(), chadterms[direction][1]["win"]) then
      show_term()
   else
      hide_term()
   end
   on_action(chadterms)
end

return M
