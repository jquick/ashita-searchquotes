require 'common';

addon.name    = 'searchquotes';
addon.version = '1.0.0';
addon.author  = 'jquick';

local AT_MARKER = string.char(0xFD);
local AT_PATTERN = AT_MARKER .. '(.-)' .. AT_MARKER;
local QUOTE = string.char(0x22);
local QUOTED_AT = QUOTE .. AT_MARKER;

ashita.events.register('command', 'command_cb', function(e)
    local cmd = e.command;
    local lower = cmd:lower();

    if not (lower:startswith('/sea ') or lower:startswith('/search ')) then
        return false;
    end

    if not cmd:find(AT_MARKER, 1, true) then
        return false;
    end

    if cmd:find(QUOTED_AT, 1, true) then
        return false;
    end

    local result = cmd:gsub(AT_PATTERN, function(match)
        return QUOTE .. AT_MARKER .. match .. AT_MARKER .. QUOTE;
    end);

    if result ~= cmd then
        e.blocked = true;
        AshitaCore:GetChatManager():QueueCommand(1, result);
    end

    return false;
end);

ashita.events.register('load', 'load_cb', function()
    print('[searchquotes] Loaded. Auto-translate phrases in /sea will be quoted automatically.');
end);

ashita.events.register('unload', 'unload_cb', function()
    print('[searchquotes] Unloaded.');
end);