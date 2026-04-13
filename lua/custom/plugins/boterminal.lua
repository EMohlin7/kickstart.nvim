local state = {
  window = {
    buf = -1,
    win = -1,
  },
  pre_win = -1,
}
local global_pre_win = -1

local windowHeight = 15

vim.api.nvim_create_autocmd('WinLeave', {
  callback = function() global_pre_win = vim.api.nvim_get_current_win() end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  callback = function()
    if vim.api.nvim_win_is_valid(state.window.win) then
      if state.window.win == vim.api.nvim_get_current_win() then state.pre_win = global_pre_win end
    end
  end,
})

local function OpenBottomWindow(height, buf)
  height = height or 10

  if not vim.api.nvim_buf_is_valid(buf) then buf = vim.api.nvim_create_buf(false, true) end
  -- Go to the bottom-rightmost window first

  -- Create a split at the very bottom
  vim.cmd 'botright split'
  vim.api.nvim_win_set_height(0, height)
  vim.api.nvim_win_set_buf(0, buf)
  return { buf = buf, win = vim.api.nvim_get_current_win() }
end

local boterminal = function()
  if not vim.api.nvim_win_is_valid(state.window.win) then
    local win = vim.api.nvim_get_current_win()
    state.window = OpenBottomWindow(windowHeight, state.window.buf)
    state.pre_win = win

    if vim.bo[state.window.buf].buftype ~= 'terminal' then vim.cmd.terminal() end
  else
    if state.window.win ~= vim.api.nvim_get_current_win() then state.pre_win = vim.api.nvim_get_current_win() end
    vim.api.nvim_win_hide(state.window.win)

    if vim.api.nvim_win_is_valid(state.pre_win) then vim.api.nvim_set_current_win(state.pre_win) end
  end
end

---@module 'lazy'
---@type LazySpec
return {
  vim.api.nvim_create_user_command('Boterminal', boterminal, { desc = 'Toggle a terminal window at the bottom of the screen' }),
}
