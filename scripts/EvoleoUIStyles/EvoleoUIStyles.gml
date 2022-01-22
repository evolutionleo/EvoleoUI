global.evoui_stylesheets = []
global.evoui_main_stylesheet = new StyleSheet()


///@function	Style(selector, style)
///@param		{string|Selector} selector
///@param		{struct} style
function Style(selector, style) constructor {
	var _ = argument[0]
	
	// new Style({ prop: value }), without a selector
	if is_undefined(style) {
		style = selector
		selector = "*"
	}
	else if is_undefined(selector) and !is_undefined(style) {
		selector = "*"
	}
	
	__is_style = true
	
	display = "block" // "inline" | "block" ("flex" coming soon)
	position = "relative" // "relative" | "absolute"
	
	color = c_black
	font = -1
	
	bg_color = c_red
	bg_alpha = 0
	bg_sprite = -1 // sprite index
	bg_image = 0 // image index
	
	/** @type {Real} */
	x = undefined
	/** @type {Real} */
	y = undefined
	/** @type {Real} */
	width = undefined
	/** @type {Real} */
	height = undefined
	
	/** @type {Real} */
	min_width = undefined
	/** @type {Real} */
	min_height = undefined
	
	/** @type {Real} */
	max_width = undefined
	/** @type {Real} */
	max_height = undefined
	
	
	/** @type {Struct.UIPadding} */
	padding = new UIPadding()
	
	/** @type {Struct.UIBorder} */
	border = new UIBorder()
	
	/** @type {Struct.UIMargin} */
	margin = new UIMargin()
	
	halign = fa_left
	valign = fa_top
	
	// the list of variables that are not their default values
	set_properties = []
	static touch = function(prop_name) { array_push(set_properties, prop_name) }
	static propertyIsSet = function(prop_name) {
		var i = 0
		repeat(array_length(set_properties)) {
			if (set_properties[i] == prop_name)
				return true
			i++
		}
		return false
	}
	
	if is_string(selector)
		selector = new SimpleSelector(selector)
	else if !isSelector(selector) // error out
		throw "error: selector must either a string or an instance of Selector. got " + typeof(selector)
	
	/** @type {Struct.Selector} */
	self.selector = selector
	
	static getPriority = function() {
		return selector.getPriority()
	}
	
	// usage: new Style("selector", { ... }).g()
	/**
	@function apply()
	*/
	static apply = function() { global.evoui_main_stylesheet.addStyle(self) }
	static Global = apply
	static g = apply
	
	
	static set = function(prop_name, value, raw = false) {
		trace("setting % to %", prop_name, value)
		if (string_pos(".", prop_name)) {
			var name_value = string_split(prop_name, ".")
			var struct_name = name_value[0]
			var struct_var_name = name_value[1]
			
			var struct = variable_struct_get(self, struct_name)
			variable_struct_set(struct, struct_var_name, value)
			
			trace("%.% = %", struct_name, struct_var_name, value)
		}
		else {
			if (raw) { // set directly
				variable_struct_set(self, prop_name, value)
			}
			else {
				var_setter(self, prop_name, value)
			}
		}
		
		touch(prop_name)
	}
	
	// works with things like "margin.top", etc.
	static get = function(prop_name) {
		if (string_pos(".", prop_name)) {
			var name_value = string_split(prop_name, ".")
			var struct_name = name_value[0]
			var struct_var_name = name_value[1]
			
			var struct = variable_struct_get(self, struct_name)
			return variable_struct_get(struct, struct_var_name)
		}
		else {
			return variable_struct_get(self, prop_name)
		}
	}
	
	static var_setter = function(s, var_name, var_value) {
		// unset
		if var_value == undefined
			return -1
		
		with(s) {
		switch(var_name) {
			#region Margin
			
			case "margin":
				if is_real(var_value) {
					margin = new UIMargin(var_value, var_value, var_value, var_value)
				}
				else if is_struct(var_value) {
					margin = __merge_structs(margin, var_value)
				}
				break
			case "margin_right":
			case "marginRight":
			case "margin-right":
				margin.right = var_value
				touch("margin.right")
				break
			case "margin_top":
			case "marginTop":
			case "margin-top":
				margin.top = var_value
				touch("margin.top")
				break
			case "margin_left":
			case "marginLeft":
			case "margin-left":
				margin.left = var_value
				touch("margin.left")
				break
			case "margin_bottom":
			case "marginBottom":
			case "margin-bottom":
				margin.bottom = var_value
				touch("margin.bottom")
				break
			
			#endregion
			#region Border
			
			case "border":
				if is_real(var_value) {
					border.right = var_value
					border.top = var_value
					border.left = var_value
					border.bottom = var_value
				}
				else if is_struct(var_value) {
					border = __merge_structs(border, var_value)
				}
				else {
					throw "Border should either be real or struct, got: " + typeof(var_value)
				}
				
				touch("border")
				break
			case "border_width":
			case "borderWidth":
			case "border-width":
				border.right = var_value
				border.top = var_value
				border.left = var_value
				border.bottom = var_value
				
				touch("border")
				break
			case "border_right":
			case "borderRight":
			case "border-right":
				border.right = var_value
				touch("border.right")
				break
			case "border_top":
			case "borderTop":
			case "border-top":
				border.top = var_value
				touch("border.top")
				break
			case "border_left":
			case "borderLeft":
			case "border-left":
				border.left = var_value
				touch("border.left")
				break
			case "border_bottom":
			case "borderBottom":
			case "border-bottom":
				border.bottom = var_value
				touch("border.bottom")
				break
			
			case "border_color":
			case "borderColor":
			case "border_colour":
			case "borderColour":
			case "border-color":
			case "border-colour":
				border.color = var_value
				touch("border.color")
				break
			
			#endregion
			#region Padding
			
			case "padding":
				if is_real(var_value) {
					padding = new UIPadding(var_value, var_value, var_value, var_value)
				}
				else if is_struct(var_value) {
					padding = __merge_structs(padding, var_value)
				}
				
				touch("padding")
				break
			case "padding_right":
			case "paddingRight":
			case "padding-right":
				padding.right = var_value
				touch("padding.right")
				break
			case "padding_top":
			case "paddingTop":
			case "padding-top":
				padding.top = var_value
				touch("padding.top")
				break
			case "padding_left":
			case "paddingLeft":
			case "padding-left":
				padding.left = var_value
				touch("padding.left")
				break
			case "padding_bottom":
			case "paddingBottom":
			case "padding-bottom":
				padding.bottom = var_value
				touch("padding.bottom")
				break
			
			#endregion
			#region Background
			
			case "bg_color":
			case "bg-color":
			case "background_color":
			case "background-color":
				bg_color = var_value
				touch("bg_color")
				
				if !propertyIsSet("bg_alpha") {
					bg_alpha = 1
					touch("bg_alpha")
				}
				break
			
			#endregion
			#region Align
			
			case "halign":
				if is_real(var_value)
					halign = var_value
				else if is_string(var_value) {
					switch(string_lower(var_value)) {
						case "left":
						case "fa_left":
							halign = fa_left
							break
						case "right":
						case "fa_right":
							halign = fa_right
							break
						case "middle":
						case "center":
						case "fa_middle":
						case "fa_center":
							halign = fa_middle
							break
					}
				}
				else {
					throw "halign expected of type string/number, got: " typeof(var_value)
				}
				
				touch("halign")
				break
			case "valign":
				if is_real(var_value)
					valign = var_value
				else if is_string(var_value) {
					switch(string_lower(var_value)) {
						case "top":
						case "fa_top":
							valign = fa_top
							break
						case "bottom":
						case "down":
						case "fa_bottom":
							valign = fa_bottom
							break
						case "middle":
						case "center":
						case "fa_middle":
						case "fa_center":
							valign = fa_center
							break
					}
				}
				else {
					throw "valign expected of type string/number, got: " typeof(var_value)
				}
				
				touch("valign")
				break
			#endregion
			#region Size
			
			case "min_width":
			case "min-width":
			case "minWidth":
				min_width = var_value
				touch("min_width")
				break
			case "max_width":
			case "max-width":
			case "maxWidth":
				max_width = var_value
				touch("max_width")
				break
			case "min_height":
			case "min-height":
			case "minHeight":
				min_height = var_value
				touch("min_height")
				break
			case "max_height":
			case "maxheight":
			case "maxHeight":
				max_height = var_value
				touch("max_height")
				break
			
			#endregion
			
			default:
				variable_struct_set(self, var_name, var_value)
				touch(var_name)
				break
		}
		}
	}
	
	// merges a Style
	static mergeStyle = function(style) {
		if isStyle(style) {
			var set_names = style.set_properties, i = 0
			repeat(array_length(set_names)) {
				var name = set_names[i]
				var value = style.get(name)
				set(name, value, true)
				i++
			}
		}
		else if is_struct(style) {
			__merge_structs(self, style, var_setter)
		}
		else {
			throw "Can't merge style of type: " + typeof(style)
		}
	}
	
	// inherit the argument
	mergeStyle(style)
}

///@function	StyleSheet(styles) -> StyleSheet
///@param		{struct|array} styles
function StyleSheet(_styles = []) constructor {
	__is_stylesheet = true
	
	styles = []
	
	if is_array(_styles) {
		for(var i = 0; i < array_length(_styles); ++i) {
			styles[i] = _styles[i]
		}
	}
	else if isStyle(_styles) {
		styles[0] = _styles
	}
	else if is_struct(_styles) {
		var keys = variable_struct_get_names(_styles)
		for(var i = 0; i < array_length(keys); ++i) {
			var selector = keys[i] // key
			var style = _styles[$ (selector)] // value
			if (is_struct(style)) {
				styles[i] = new Style(selector, style)
			}
			else {
				throw "Expected a struct for style, got " + typeof(style) + " (" + string(style) + ")"
			}
		}
	}
	
	array_push(global.evoui_stylesheets, self)
	
	static addStyle = function(style) {
		array_push(styles, style)
		
		sortStyles()
	}
	
	static clearStyles = function() {
		styles = []
	}
	
	// sort styles by priority
	static sortStyles = function() {
		array_sort(styles, function(s1, s2) {
			return s2.getPriority() - s1.getPriority()
		})
	}
	
	static remove = function() {
		var l = array_length(global.evoui_stylesheets)
		for(var i = 0; i < l; i++) {
			if (global.evoui_stylesheets[i] == self) {
				array_delete(global.evoui_stylesheets, i, 1)
				break
			}
		}
	}
}


// parent abstract class
function Selector() constructor {
	__is_selector = true
	
	static matches = function(element) {
		throw "error: selector.matches() is not defined!"
	}
	
	static getPriority = function() {
		return 0
	}
}

///@function	SimpleSelector(selector)
///@param		{string} selector
function SimpleSelector(_selector) : Selector() constructor {
	selector = _selector
	selected_id = undefined
	selected_class = undefined
	selected_tag = undefined
	
	if !is_string(selector) {
		throw "selector should be a string! got " + typeof(selector)
	}
	
	
	for(var i = 1; i <= string_length(selector); i = segment_end + 1) {
		var segment_end = min(
							string_pos_ext(".", selector, i),
							string_pos_ext("#", selector, i),
							string_pos_ext("*", selector, i)
							)
		if (segment_end == 0) {
			segment_end = string_length(selector)
		}
		
		// initialize
		if (string_char_at(selector, 1) == ".") { // class name
			selected_class = string_copy(selector, 2, segment_end-i)
		}
		else if (string_char_at(selector, 1) == "#") { // id
			selected_id = string_copy(selector, 2, segment_end-i)
		}
		else if (selector == "*") {}
		else { // the whole thing is a tag name
			selected_tag = selector
		}
	}
	
	
	static matches = function(element) {
		if (selector == "*")
			return true
		
		if (!is_undefined(selected_tag)) {
			if element.__element_type != selected_tag
				return false
		}
		if (!is_undefined(selected_class)) {
			if element.class != selected_class
				return false
		}
		if (!is_undefined(selected_id)) {
			if element.id != selected_id
				return false
		}
		
		
		return true
	}
	
	static getPriority = function() {
		return !is_undefined(selected_id) * 100 + !is_undefined(selected_class) * 10 + !is_undefined(selected_tag) * 1
	}
}


// TODO: actually implement CSS importing
function loadStyleCSS(path) {
	var text = string_from_file(path)
	var sheet = new StyleSheet()
	
	var pos = 1
	
	while(string_pos_ext("", text, pos)) {
		
	}
	
	return sheet
}


///@function	isStyleSheet(value) -> bool
///@param		{any} value
///@returns		{bool} result
function isStyleSheet(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_stylesheet") and v.__is_stylesheet
}

function isStyle(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_style") and v.__is_style
}

function isSelector(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_selector") and v.__is_selector
}


function BoundsBox(right = 0, top = 0, left = 0, bottom = 0) constructor {
	self.right = right
	self.top = top
	self.left = left
	self.bottom = bottom
}

function UIPadding(right = 0, top = 0, left = 0, bottom = 0) : BoundsBox(right, top, left, bottom) constructor {}

function UIBorder(color = c_black, right = 0, top = 0, left = 0, bottom = 0) : BoundsBox(right, top, left, bottom)  constructor {
	self.color = color
}

function UIMargin(right = 0, top = 0, left = 0, bottom = 0) : BoundsBox(right, top, left, bottom) constructor {}