-----------------------------------------------------------------------
-- luakit configuration file, more information at http://luakit.org/ --
-----------------------------------------------------------------------
--
-- Load library of useful functions for luakit
require "lousy"

-- Small util functions to print output (info prints only when luakit.verbose is true)
function warn(...) io.stderr:write(string.format(...) .. "\n") end
function info(...) if luakit.verbose then io.stderr:write(string.format(...) .. "\n") end end

-- Load users global config
require "globals"

-- Load users theme
lousy.theme.init(lousy.util.find_config("theme.lua"))
theme = assert(lousy.theme.get(), "failed to load theme")

-- Load users window class
require "window"

-- Load users webview class
require "webview"

-- Load users mode configuration
require "modes"

-- Load users keybindings
require "binds"

-- Add command history
require "cmdhist"

-- Add search mode & binds
require "search"

require "go_input"

-- hijack functions necessary to redirect external links

webview.init_funcs.window_decision = function (view, w)
    view:add_signal("new-window-decision",
        function (v, uri, reason)
            local cmd = string.format("%s %q", "xdg-open", uri)
            luakit.spawn(cmd)
            return true
        end
    )
end

-- cosmetic - prevents "flicker" on page transitions/new tabs
webview.init_funcs.set_win_trans = function (view, w) -- show GTK the background color
    view.transparent = true
end

window.new(uris)

