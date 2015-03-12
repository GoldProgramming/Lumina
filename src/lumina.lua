-- uses LuaFileSystem and cqueues
-- startup stuff
do
	--[[function _err( str )
		error( setmetatable( {}, {__tostring=function() return str end} ) )
	end]] _err = error
	local ok;
	ok, cqueues = pcall( require, "cqueues" )
	if not ok then
		_err( "cqueues library not found!" )
	end
	ok, lfs = pcall( require, "lfs" )
	if not ok then
		_err( "lfs library not found!" )
	end
	local func, err = loadfile( "lib/lumina.lua" )
	if not func then
		_err( "lumina library unloadable:\n" .. err )
	end
	ok, lumina = pcall( func )
	if not ok then
		_err( "lumina module unloadable:\n" .. err)
	end
	if lfs.attributes( "config.json", "mode" ) ~= "file" then
		_err( "unable to locate config.json configuration file!" )
	end
	local f, err = io.open( "config.json" )
	if not f then _err( err ) end
	json = require( "lib.json" )
	local t = json.decode( f:read( "*a" ) )
	f:close()
	items = {
		coroutine = {},
		program = {}
	}
	config = {}
	function getconf(t)
		for k, v in pairs( t ) do
			if not items[v['type']] then
				items[v['type']] = {}
			end
			items[v['type']][v['name']] = v
			if v['type'] == "configuration" then
				for _k, _v in pairs( v ) do
					if type( _v ) == "table" then
						for __k, __v in pairs( _v ) do
							(config[_k] or (function()config[_k]={}return config[_k]end)())[__k] = __v
						end
					else
						config[_k] = _v
					end
				end
			end
		end
	end
	getconf( t )
	if config.modified == false then
		_err( "config.json labeled unmodified!" )
	end
	if config.include then
		local mkwc = require( "lib.mkwc" )
		local getdir = require( "lib.getdir" )
		for k, v in pairs( config.include ) do
			local t = getdir( "." )
			for _, line in pairs( t ) do
				if line:match( mkwc( v ) ) then
					local f, err = io.open( line )
					if not f then _err( err ) end
					local t, _, err = json.decode( f:read( "*a" ) )
					f:close()
					if not t then _err( line .. ": " .. err ) end
					getconf( t )
				end
			end
		end
	end
end
-- start coroutines
for k, v in pairs( items['coroutine'] ) do
	local found;
	if not v.directory then
		return _err( "Directory missing for coroutine " .. k )
	end
	for item in lfs.dir( v.directory ) do
		if v.file or item:match( "main%.lua$" ) or item:match( "main%.srv$" ) or item:match( "main%.cli$" ) then
			local f, err = loadfile( v.directory:match( "(.-)/?$" ) .. "/" .. ( v.file or item ) )
			if not f then
				_err( err )
				found = true
			else
				lumina:queue( f, k )
				found = true
			end
		end
	end
	if not found then _err( "Missing file for coroutine " .. k ) end
end
-- start threads
for k, v in pairs( items['program'] ) do
	local found;
	if not v.directory then
		return _err( "Directory missing for thread " .. k )
	end
	for item in lfs.dir( v.directory ) do
		if v.file or item:match( "main%.lua$" ) or item:match( "main%.srv$" ) or item:match( "main%.cli$" ) then
			local f, err = loadfile( v.directory:match( "(.-)/?$" ) .. "/" .. ( v.file or item ) )
			if not f then
				_err( err )
				found = true
			else
				lumina:spawn( f, k )
				found = true
			end
		end
	end
	if not found then _err( "Missing file for thread " .. k ) end
end
-- loop through coroutines
while not lumina.queues:empty() do
	local k, err = lumina.queues:step()
	if not k then
		print( "Error: " .. err )
	end
end
