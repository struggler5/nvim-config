vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.relativenumber = true
local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },{
    'Thiago4532/mdmath.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
opts = {
    -- Filetypes that the plugin will be enabled by default.
    filetypes = {'markdown'},
    -- Color of the equation, can be a highlight group or a hex color.
    -- Examples: 'Normal', '#ff0000'
    foreground = 'Normal',
    -- Hide the text when the equation is under the cursor.
    anticonceal = true,
    -- Hide the text when in the Insert Mode.
    hide_on_insert = true,
    -- Enable dynamic size for non-inline equations.
    dynamic = true,
    -- Configure the scale of dynamic-rendered equations.
    dynamic_scale = 1.0,
    -- Interval between updates (milliseconds).
    update_interval = 400,

    -- Internal scale of the equation images, increase to prevent blurry images when increasing terminal
    -- font, high values may produce aliased images.
    -- WARNING: This do not affect how the images are displayed, only how many pixels are used to render them.
    --          See `dynamic_scale` to modify the displayed size.
    internal_scale = 1.0,
},
    build = ':MdMath build',
    -- The build is already done by default in lazy.nvim, so you don't need
    -- the next line, but you can use the command `:MdMath build` to rebuild
    -- if the build fails for some reason.
},{
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
},{
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup()
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
},{
  "okuuva/auto-save.nvim",
  version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  opts = {
    -- your config goes here
    -- or just leave it empty :)
  },
}, {
  "sphamba/smear-cursor.nvim",
  opts = {stiffness = 0.8,               -- 0.6      [0, 1]
    trailing_stiffness = 0.5,      -- 0.3      [0, 1]
    distance_stop_animating = 0.5,},
},
    {
    "slugbyte/lackluster.nvim",
    lazy = false,
        init = function()
        vim.cmd.colorscheme("lackluster")
         vim.cmd.colorscheme("lackluster-hack") -- my favorite
         vim.cmd.colorscheme("lackluster-mint")
    end,
}
    ,{
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
},{
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
      dir_path = {"images",  "%:t:r"},
      debug = false,
file_name = "%Y-%m-%d-%H-%M-%S",
url_encode_path = false,
use_absolute_path = false,
relative_to_current_file = true,
prompt_for_file_name = false,
show_dir_path_in_prompt = true,
use_cursor_in_template = true,
insert_mode_after_paste = true,
embed_image_as_base64 = false,
max_base64_size = 10,
template = "$FILE_PATH",
    -- add options here
    -- or leave it empty to use the default settings
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
},
  { import = "plugins" },
}, lazy_config)
vim.g.mkdp_browser = { "/bin/google-chrome" }
-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
-- default config:
require "options"
require "nvchad.autocmds"
require("mason").setup()
require('neoscroll').setup({ mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'} })
require("mason-lspconfig").setup()
-- default config:
-- default config:
-- default config:
require('peek').setup({
  auto_load = true,         -- whether to automatically load preview when
                            -- entering another markdown buffer
  close_on_bdelete = true,  -- close preview window on buffer delete

  syntax = true,            -- enable syntax highlighting, affects performance

  theme = 'dark',           -- 'dark' or 'light'

  update_on_change = true,

  app = 'Google Chrome',          -- 'webview', 'browser', string or a table of strings
                            -- explained below

  filetype = { 'markdown' },-- list of filetypes to recognize as markdown

  -- relevant if update_on_change is true
  throttle_at = 200000,     -- start throttling when file exceeds this
                            -- amount of bytes in size
  throttle_time = 'auto',   -- minimum amount of time in milliseconds
                            -- that has to pass before starting new render
})
require('neoscroll').setup({
  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>', '<C-d>',
    '<C-b>', '<C-f>',
    '<C-y>', '<C-e>',
    'zt', 'zz', 'zb',
  },
  hide_cursor = true,          -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 1.0,   -- Global duration multiplier
  easing = 'linear',           -- Default easing function
  pre_hook = nil,              -- Function to run before the scrolling animation starts
  post_hook = nil,             -- Function to run after the scrolling animation ends
  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  ignored_events = {           -- Events ignored while scrolling
      'WinScrolled', 'CursorMoved'
  },
})
-- default config:
-- After setting up mason-lspconfig you may set up servers via mason-lspconfig
require("lspconfig").lua_ls.setup {}
--require("mdmath").setup()
require("smear_cursor").enabled = true
require("lspconfig").textlsp.setup {}
require("lspconfig").texlab.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").pyright.setup {}
-- require("lspconfig").rust_analyzer.setup {}
-- ...
vim.schedule(function()
  require "mappings"
end)
