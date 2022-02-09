local M = {}

local get_cmds = function(window_opts)
   local get_dims = function (direction)
      local direction_switch = direction == "horizontal"
      local direction_func = direction_switch and vim.api.nvim_win_get_height or vim.api.nvim_win_get_width
      local assignment = direction_switch and "split_height" or "vsplit_width"
      return math.floor(direction_func(0)*window_opts[assignment])
   end
   local cmds = {
     horizontal = {
       existing = "rightbelow vsplit",
       new = "botright " .. get_dims("horizontal") .. "split",
       resize = "resize",
     },
     vertical = {
       existing = "rightbelow split",
       new = "botright " .. get_dims("vertical") .. "vsplit",
       resize = "vertical resize",
     },
   }
   return cmds
end

local function on_action(chadterms)
   Globals.chadterms = chadterms
end

local function on_new_buf()
   local bufs = vim.api.nvim_list_bufs()
   local term_buf_id = bufs[#bufs]
   vim.api.nvim_input('i') --term enter
   return term_buf_id
end

local function on_new_win()
   local wins = vim.api.nvim_list_wins()
   local term_win_id = wins[#wins]
   vim.api.nvim_set_current_win(term_win_id)
   return term_win_id
end
local function spawn(spawn_cmd, type)
   vim.cmd(spawn_cmd)
   return type == "win" and on_new_win() or type == "buf" and on_new_buf()
end

function M.new_or_toggle (direction, window_opts)
   local chadterms = Globals.chadterms
   local cmds = get_cmds(window_opts)

   local function new_term()
      local term_win_id=spawn(cmds[direction]["new"], "win")
      local term_buf_id=spawn("term", "buf")
      chadterms[direction][1] = { win = term_win_id, buf = term_buf_id }
   end

   local function hide_term()
      local term_id = chadterms[direction][1]["win"]
      vim.api.nvim_set_current_win(term_id)
      vim.cmd('hide')
      --no update necessary, win will be invalid on hide
   end

   local function show_term()
      local term_buf_id = chadterms[direction][1]["buf"]
      local term_win_id = spawn(cmds[direction]["new"], "win")
      vim.api.nvim_set_current_buf(term_buf_id)
      vim.api.nvim_input('i') --term enter
      chadterms[direction][1] = { win = term_win_id, buf = term_buf_id }
   end

   local opened = chadterms[direction]
   if not opened or vim.tbl_isempty(opened) then
      new_term()
   elseif vim.api.nvim_win_is_valid(chadterms[direction][1]["win"]) then
      hide_term()
   elseif vim.api.nvim_buf_is_valid(chadterms[direction][1]["buf"]) then
      show_term()
   else
      new_term()
   end
   on_action(chadterms)
end

return M
