global.__packed_data =  {}
global.__pack_stack = []
 
///@function getNextHash() -> string hash
function getNextHash() {
	static hash_id = 0
	hash_id++
	
	hash = md5_string_unicode(string(hash_id))
	hash = string_copy(hash, 0, 8)
	
	return hash
}

///@function pack(data, *name) -> string name
///@param {any} data
///@param {string} *name
function pack(data, name) {
	if (is_undefined(argument[1])) {
		name = getNextHash()
		array_push(global.__pack_stack, name)
	}
	global.__packed_data[$ name] = data
	
	return name
}

///@function unpack(*name) -> any
///@param {string} *name
function unpack(name) {
	if (is_undefined(argument[0])) {
		if array_length(global.__pack_stack) {
			name = array_last(global.__pack_stack)
		}
		else {
			return undefined
		}
	}
	return global.__packed_data[$ name]
}

///@function depack(*name) -> bool
///@param {string} *name
function depack(name) {
	if is_undefined(argument[0]) {
		name = array_pop(global.__pack_stack)
	}
	else if (array_length(global.__pack_stack)) and (name == array_last(global.__pack_stack)) {
		name = array_pop(global.__pack_stack)
	}
	if (is_undefined(name))
		return -1
	
	variable_struct_remove(global.__packed_data, name)
	return true
}

///@function repack(data, *name) -> string name
///@param {any} data
///@param {string} *name
function repack(data, name) {
	if (is_undefined(argument[1])) {
		if (!array_length(global.__pack_stack))
			return undefined
		
		name = array_last(global.__pack_stack)
		array_push(global.__pack_stack, name)
	}
	
	depack(name)
	return pack(data, name)
}


function array_last(arr) {
	return arr[array_length(arr)-1]
}
