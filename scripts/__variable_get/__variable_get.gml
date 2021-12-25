function __var_get(scope, name) {
	if (scope == global) {
		return variable_global_get(name)
	}
	else if (is_real(scope)) {
		if (instance_exists(scope)) {
			return variable_instance_get(scope, name)
		}
		else {
			throw "instance does not exist! id: " + string(scope)
		}
	}
	else if (is_struct(scope)) {
		return variable_struct_get(scope, name)
	}
}

function __var_exists(scope, name) {
	if (scope == global) {
		return variable_global_exists(name)
	}
	else if (is_real(scope)) {
		if (instance_exists(scope)) {
			return variable_instance_exists(scope, name)
		}
		else {
			throw "instance does not exist! id: " + string(scope)
		}
	}
	else if (is_struct(scope)) {
		return variable_struct_exists(scope, name)
	}
}

function __var_set(scope, name, value) {
	if is_string(scope) // "oObject"
		scope = asset_get_index(name)
	
	if (scope == global) {
		return variable_global_set(name, value)
	}
	else if (is_real(scope)) {
		if (instance_exists(scope)) {
			return variable_instance_set(scope, name, value)
		}
		else {
			throw "instance does not exist! id: " + string(scope)
		}
	}
	else if (is_struct(scope)) {
		return variable_struct_set(scope, name, value)
	}
}