local function makewildcard( str )
	return str:gsub( "%.%[%]%-%+%?%(%)", "%%%1" ):gsub( "%*", ".+" )
end
