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

   local function new_term()
      vim.cmd(cmds[direction]["new"])
      local wins = vim.api.nvim_list_wins()
      local term_win_id = wins[#wins]
      vim.api.nvim_set_current_win(term_win_id)
      vim.cmd("term")
      vim.api.nvim_input('i')
      local bufs = vim.api.nvim_list_bufs()
      local term_buf_id = bufs[#bufs]
      chadterms[direction][1] = { win = term_win_id, buf = term_buf_id }
   end

   local function hide_term()
      local term_id = chadterms[direction][1]["win"]
      if term_id then
         vim.api.nvim_set_current_win(term_id)
         vim.cmd('hide')
      end
   end

   local function show_term()
      print("show")
      local term_buf_id = chadterms[direction][1]["buf"]
      if vim.api.nvim_buf_is_valid(term_buf_id) then
         print(term_buf_id)
         vim.cmd("unhide " .. term_buf_id)
      --    vim.cmd(cmds[direction]["new"])
      --    local wins = vim.api.nvim_list_wins()
      --    vim.api.nvim_set_current_win(wins[#wins])
      --    vim.api.nvim_win_set_buf(0, term_buf)
      --    chadterms[direction][1]["win"] = wins[#wins]
      else
         new_term()
      end
   end

   local opened = chadterms[direction]
   if not opened or vim.tbl_isempty(opened) then
      new_term()
   elseif vim.api.nvim_win_is_valid(chadterms[direction][1]["win"]) then
      hide_term()
   elseif vim.api.nvim_buf_is_valid(chadterms[direction][1]["buf"]) then
      show_term()
   else
      print("new")
      new_term()
   end
   on_action(chadterms)
end

return M
