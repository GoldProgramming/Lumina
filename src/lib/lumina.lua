-- lumina general libraries file.

local lumina = {}
lumina.objects = {}
lumina.programs = {}
lumina.queues = cqueues.new()

function lumina:spawn( func, name )
	local k, thread = require( "cqueues.thread" )
	if not k then
		_err( "cqueues.thread module not found!" )
	end
	local thr, con = thread.start( func )
	local obj = setmetatable( { thread = thr, connection = con, type = "thread" }, { __index = lumina } )
	lumina.programs[name] = obj
	lumina.objects[name] = obj
	return obj
end

function lumina:stop( reason )
	return (reason and self.connection:send( "QUIT :" .. reason ) or self.connection:send( "QUIT" )) and nil
end

function lumina:program( file, name )
	local f, err = io.open( file )
	if not f then _err( file .. ": " .. err ) end
	local func, err = loadstring( f:read( "*a" ) )
	if not func then _err( file .. ": " .. err ) end
	return self:spawn( func, name )
end

function lumina:queue( func, name )
	self.queues:wrap( func )
	lumina.objects[name] = { func = func, type = "coroutine" }
end


return lumina
