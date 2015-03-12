-- lumina general libraries file.

local lumina = {}
lumina.programs = {}

function lumina:spawn( func, name )
	local k, thread = require( "cqueues.thread" )
	if not k then
		_err( "cqueues.thread module not found!" )
	end
	local thr, con = thread.start( func )
	local obj = setmetatable( { thread = thr, connection = con }, { __index = lumina } )
	lumina.programs[name] = obj
	return obj
end

function lumina:stop( reason )
	return reason and self.connection:send( "QUIT :" .. reason ) or self.connection:send( "QUIT" )
end

return lumina
