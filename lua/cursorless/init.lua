-- local Config = require('cursorless.config')

-- TODO: we can't use that yet as then when we use load_extensions() we get an error.
-- So instead atm we rely on registering the functions from vim script
-- local function register_functions1()
--   local path = require('cursorless.utils').cursorless_nvim_path()
--   vim.api.nvim_call_function('remote#host#RegisterPlugin', {
--     'node',
--     path .. '/rplugin/node/cursorless-neovim',
--     {
--       { sync = false, name = 'CursorlessLoadExtension', type = 'function', opts = {} },
--     },
--   })
-- end

local function register_functions()
  local path = require('cursorless.utils').cursorless_nvim_path()
  -- revert to using forward slashes as works when passed to remote#host#RegisterPlugin()
  if require('cursorless.utils').is_win() then
    path = path:gsub('\\', '/')
  end
  vim.api.nvim_call_function('CursorlessRegisterFunctions', { path })
end

-- this triggers loading the node process as well as calling one function
-- in the cursorless-neovim extension in order to initialize it
local function load_extensions()
  vim.api.nvim_call_function('CommandServerLoadExtension', {})
  vim.api.nvim_call_function('CursorlessLoadExtension', {})

  if os.getenv('CURSORLESS_MODE') == 'test' then
    -- make sure cursorless is loaded before starting the tests
    -- see https://neovim.io/doc/user/various.html#%3Asleep
    vim.cmd([[sleep 5]])
    vim.api.nvim_call_function('TestHarnessRun', {})
  end
end

local function setup() -- setup(user_config)
  -- local config = Config.merge_config(user_config)

  vim.cmd('source ' .. require('cursorless.utils').cursorless_nvim_path() .. '/vim/cursorless.vim')
  register_functions()
  load_extensions()
end

local M = {
  setup = setup,
}

return M
