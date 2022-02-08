local M = {}

vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

ChadTerms = {horizontal = {}, vertical = {}}


local function new_term(direction, exists)
   local cmds = require("chadterm").get_cmds()
   print(vim.inspect(cmds))
   if not exists then
      vim.cmd(cmds[direction]["new"])
   else
      vim.cmd(cmds[direction]["existing"])
   end
   local wins = vim.api.nvim_list_wins()
   local term_id = wins[#wins]
   ChadTerms[direction][1] = term_id
   vim.api.nvim_set_current_win(term_id)
   vim.cmd("term")
   vim.api.nvim_input('i')
end

local function hide_term(direction)
   local term_id = ChadTerms[direction][1]
   if term_id then
      vim.api.nvim_set_current_win(term_id)
      vim.cmd('hide')
   end
end

local function show_term(direction)
   local term_id = nil
   local prev_wins = vim.api.nvim_list_wins()
   vim.cmd('unhide')
   local new_wins = vim.api.nvim_list_wins()
   for _,v in ipairs(new_wins) do
      if not vim.tbl_contains(prev_wins, v) then
         term_id = v
         ChadTerms[direction][1] = term_id
      end
   end
   if term_id ~= nil then
      vim.api.nvim_set_current_win(term_id)
      vim.api.nvim_input('i')
   else
      new_term(direction)
   end
end

function M.new_or_toggle (direction)
   if (vim.tbl_isempty(ChadTerms[direction]) or not ChadTerms[direction][1]) then
      new_term(direction)
   elseif not vim.tbl_contains(vim.api.nvim_list_wins(), ChadTerms[direction][1]) then
      show_term(direction)
   else
      hide_term(direction)
   end
end

return M
