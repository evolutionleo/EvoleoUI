
function __merge_structs(s1, s2, setter = variable_struct_set) {
	var var_names = variable_struct_get_names(s2)
	var var_len = variable_struct_names_count(s2)
	for(var i = 0; i < var_len; ++i) {
		var var_name = var_names[i]
		var var_value = variable_struct_get(s2, var_name)
		setter(s1, var_name, var_value)
	}
	
	return s1
}