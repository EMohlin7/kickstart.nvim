return {
  'nickjvandyke/opencode.nvim',
  version = '*', -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      'folke/snacks.nvim',
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...) return require('opencode').snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ 'n', 'x' }, '<leader>oae', function() require('opencode').ask(' ', { submit = true }) end, { desc = 'Ask opencode…' })
    vim.keymap.set({ 'n', 'x' }, '<leader>oat', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode about this…' })
    vim.keymap.set(
      { 'n', 'x' },
      '<leader>oaf',
      function() require('opencode').ask('@buffer: ', { submit = true }) end,
      { desc = 'Ask opencode about this file…' }
    )
    vim.keymap.set({ 'n', 'x' }, '<leader>ox', function() require('opencode').select() end, { desc = 'Execute opencode action…' })
    vim.keymap.set({ 'n' }, '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
    vim.keymap.set({ 'n' }, '<leader>on', function() require('opencode').command 'session.new' end, { desc = 'New opencode session' })
    vim.keymap.set({ 'n' }, '<leader>om', function() require('opencode').command 'model.list' end, { desc = 'Change opencode model' })
    vim.keymap.set({ 'n' }, '<leader>o<Tab>', function() require('opencode').command 'agent.cycle' end, { desc = 'Cycle opencode agent' })

    --vim.keymap.set({ 'n', 'x' }, 'go', function() return require('opencode').operator '@this ' end, { desc = 'Add range to opencode', expr = true })
    --vim.keymap.set('n', 'goo', function() return require('opencode').operator '@this ' .. '_' end, { desc = 'Add line to opencode', expr = true })

    vim.keymap.set('t', '<C-u>', function() require('opencode').command 'session.half.page.up' end, { desc = 'Scroll opencode up' })
    vim.keymap.set('t', '<C-d>', function() require('opencode').command 'session.half.page.down' end, { desc = 'Scroll opencode down' })
  end,
}
