global.evoui_canvases = []


#macro UI_WIDTH (display_get_gui_width())
#macro UI_HEIGHT (display_get_gui_height())


function UIElement(props = {}, children = []) constructor {
	__is_uielement = true
	__element_type = instanceof(self)
	
	mounted = false
	
	self.children = children
	self.props = props
	
	parent = undefined
	canvas = undefined
	
	x = 0
	y = 0
	
	width = 100
	height = 100
	
	// read-only: where the element is actually rendered
	draw_pos = { x: 0, y: 0 }
	
	//style = new StyleSheet({})
	style = undefined
	default_style = undefined
	
	state = {}
	
	///@function	setState(state)
	///@desc		sets soem state variables
	///@param		{struct} state
	static setState = function(_state) {
		__merge_structs(state, _state)
	}
	
	
	static update = function() {
		
	}
	
	static _update = function() {
		update()
	}
	
	static draw = function() {}
	
	static drawBackground = function() {
		draw_get()
		
		if (style.bg_sprite) {
			draw_sprite_stretched(style.bg_sprite, style.bg_image, x, y, width, height)
		}
		else {
			draw_set_color(style.bg_color)
			draw_set_alpha(style.bg_alpha)
		
			draw_rectangle(x, y, x + width, y + height, false)
		}
		
		draw_reset()
	}
	
	static drawBorder = function() {
		draw_get()
		
		draw_set_color(style.border.color)
		if (style.border.left != 0) {
			draw_line_width(x - style.border.left/2, y - style.border.top, x - style.border.left/2, y + height + style.border.bottom, style.border.left)
		}
		if (style.border.right != 0) {
			draw_line_width(x + width + style.border.right/2, y - style.border.top, x + width + style.border.right/2, y + height + style.border.bottom, style.border.right)
		}
		if (style.border.top != 0) {
			draw_line_width(x - style.border.left, y - style.border.top/2, x + width + style.border.right, y - style.border.top/2, style.border.top)
		}
		if (style.border.bottom != 0) {
			draw_line_width(x - style.border.left, y + height + style.border.bottom/2, x + width + style.border.right, y + height + style.border.bottom/2, style.border.bottom)
		}
		//draw_rectangle(x - style.border.left, y - style.border.top, x + width + style.border.right, y + height + style.border.bottom, true)
		
		draw_reset()
	}
	
	static _draw = function(originX, originY) {
		draw_get()
		
		prev_x = x
		prev_y = y
		
		//show_debug_message(typeof(canvas.scroll))
		
		switch(style.position) {
			case "absolute":
				x = x + canvas.scroll.x
				y = y + canvas.scroll.y
				break
			case "relative":
				x = originX + x + canvas.scroll.x
				y = originY + y + canvas.scroll.y
				break
			default:
				throw "Error: Unknown style.position value! (" + string(style.position) + ")"
				break
		}
		
		draw_pos.x = x
		draw_pos.y = y
		
		drawBackground()
		drawBorder()
		
		x += style.padding.left
		y += style.padding.top
		
		draw_get()
		draw()
		draw_reset()
		
		x = prev_x
		y = prev_y
		
		draw_reset()
	}
	
	static renderText = function(text = "", originX = 0, originY = 0) {
		draw_get()
		
		draw_set_font(style.font)
		draw_set_color(style.color)
		draw_set_align(fa_left, fa_top)
				
		draw_text(originX + canvas.scroll.x, originY + canvas.scroll.y, text)
		
		draw_reset()
	}
	
	rendered = undefined
	about_to_rerender = false
	
	static rerender = function() {
		about_to_rerender = true
	}
	
	static render = function() {
		return []
	}
	
	static _render = function(originX = 0, originY = 0) {
		//return -1
		
		//show_debug_message("I am a " + instanceof(self) + ", and my children are: " + string(children))
		
		var pointerX = originX
		var pointerY = originY
		
		if (style.display == "none")
			return -1
		
		pointerX += style.margin.left
		pointerY += style.margin.top
		
		
		// padding is used here, but we also need the border
		_draw(pointerX, pointerY)
		
		pointerX += style.padding.left
		pointerY += style.padding.top
		
		
		if (about_to_rerender) {
			trace("rerendering %...", __element_type)
			// wipe out the previous render
			var l = array_length(rendered)
			repeat(l) {
				var _el = rendered[0]
				delete _el
				array_delete(rendered, 0, 1)
			}
			
			// new render
			rendered = render() // returns an array
			if (!is_undefined(rendered))
				rendered = UIUnwrapElements(rendered)
			else
				rendered = []
			about_to_rerender = false
		}
		else if (is_undefined(rendered)) {
			rendered = render() // returns an array
			if (!is_undefined(rendered))
				rendered = UIUnwrapElements(rendered)
			else
				rendered = []
			
			//show_message(toString() + " " + string(rendered))
			//trace("rendered is undefined for %", __element_type)
			//trace("now rendered is %", rendered)
		}
		
		var i = 0, l = array_length(rendered)
		repeat(l) {
			var _el = rendered[i]
			_el.canvas = canvas
			_el.parent = self
			
			//trace("% mounted? %", _el.__element_type, _el.mounted)
			
			if (!_el.mounted)
				_el._mount()
			i++
		}
		
		
		var _torender = get_children()
		
		var i = 0, l = array_length(_torender)
		repeat(l) {
			draw_get()
			
			var el = _torender[i]
			if isUIElement(el) {
				if (el.style.display == "none") {
					i++
					continue
				}
				else if (el.style.position == "absolute") {
					
				}
				else if (el.style.position == "relative") {
					
				}
				
				
				switch(style.display) {
					case "block": // vertically
						//show_debug_message("rendering a " + instanceof(el) + " at x=" + string(pointerX) + ", y=" + string(pointerY))
						el._render(pointerX, pointerY)
						
						pointerY += el.style.margin.top
						pointerY += el.height
						pointerY += el.style.margin.bottom
						break
					case "inline":
						//+ el.style.padding.left
						
						// not fitting on the current line
						if (pointerX + el.width + el.style.padding.right > originX + width - style.padding.right) {
							pointerX = originX

							el._render(pointerX, pointerY)
							
							pointerY += el.style.margin.top
							pointerY += el.height
							pointerY += el.style.margin.bottom
						}
						else {
							el._render(pointerX, pointerY)
						}
						
						pointerX += el.style.margin.left + el.width + el.style.margin.right
						
						break
					case "none": // don't draw anything
						break
				}
			}
			else if is_string(el) {
				renderText(el, pointerX, pointerY)
			}
			else {
				// idk something went wrong ig
				throw "Error: can't render an element of type " + typeof(el) + ". (" + string(el) + ")"
			}
			
			draw_reset()
			i++
		}
	}
	
	// returns the actual .children, joined with .rendered
	static get_children = function() {
		var _torender = []
		array_copy(_torender, 0, children, 0, array_length(children))
		if (rendered != undefined)
			array_copy(_torender, array_length(children), rendered, 0, array_length(rendered))
		
		return _torender
	}
	
	static _update = function() {
		update()
		// no
		//var i = 0, l = array_length(children)
		//repeat(l) {
		//	var c = children[i]
		//	if isUIElement(c)
		//		c._update()
		//	i++
		//}
	}
	
	static premount = function() {}
	
	static mount = function() {}
	
	static _mount = function() {
		if (!mounted) {
			premount()
		
			__merge_structs(self, props, function(s, var_name, var_value) {
				if (var_name != "style" or style == undefined)
					variable_struct_set(s, var_name, var_value)
				if is_method(var_value) { // rebind functions that are bound to "props"
					//if !isUIElement(method_get_self(var_value)) {
					if method_get_self(var_value) == props {
						variable_struct_set(s, var_name, method(s, var_value))
					}
					else {
						variable_struct_set(s, var_name, var_value)
					}
				}
			})
			//__merge_structs(self, props)
			
			if (is_undefined(default_style))
				default_style = {}
			
			if (is_undefined(style))
				style = new StyleSheet({}, default_style)
			else
				style = new StyleSheet(style, default_style)
				
			
			
			//show_message(stf("assigning styles: %", style))
		
			if (style.x != undefined)
				x = style.x
			if (style.y != undefined)
				y = style.y
	
			if (style.width != undefined) {
				//show_message("style width isn't undefined")
				width = style.width
			}
			if (style.height != undefined) {
				//show_message("style height isn't undefined")
				height = style.height
			}
		
			mount()
			
			mounted = true
			//trace("")
		}
		
		// mount the children
		var i = 0, l = array_length(children)
		repeat(l) {
			if isUIElement(children[i])
				children[i]._mount()
			i++
		}
	}
	
	//trace("called the constructor for " + __element_type)
	
	
	static toString = function(nested_level = 0) {
		var tab = string_repeat("  ", nested_level)
		var str = tab + __element_type + " " + " [\n"
		var _children = get_children()
		for(var i = 0; i < array_length(_children); i++) {
			var c = _children[i]
			//str += tab
			
			if (isUIElement(c))
				str += c.toString(nested_level+1)
			else if is_string(c)
				str += tab + "  " + "\"" + c + "\""
			else
				str += tab + "  " + string(c)
			
			if (i != array_length(_children)-1)
				str += ",\n"
		}
		
		str += "\n" + tab + "]"
		return str
	}
}

function UIClickable(props = {}, children = []) : UIElement(props, children) constructor {
	hovered = false
	clicked = false
	
	e = false
	
	static _update = function() {
		update()
		
		
		if isHovered() {
			if (!e) {
				//trace("_updatee")
				//trace(__element_type)
				e = true
			}
			onHovered()
			
			if !hovered {
				onHover()
			}
			
			hovered = true
			
			if device_mouse_check_button(0, mb_left) {
				clicked = true
				onHold()
				
				if device_mouse_check_button_pressed(0, mb_left) {
					show_debug_message("clicc")
					show_debug_message(__element_type)
					onClick()
				}
			}
			else {
				if device_mouse_check_button_released(0, mb_left) {
					onRelease()
				}
				
				clicked = false
			}
		}
		else {
			hovered = false
			clicked = false
		}
	}
	
	static isHovered = function() {
		var mx = device_mouse_raw_x(0),
			my = device_mouse_raw_y(0)
		
		return (draw_pos.x <= mx && mx <= draw_pos.x + width)
		   and (draw_pos.y <= my && my <= draw_pos.y + height)
	}
	
	// events
	static onClick = function() {} // when lmb is pressed
	static onRelease = function() {} // when lmb is released
	static onHold = function() {} // when lmb is held
	static onHover = function() {} // just hovered
	static onHovered = function() {} // while being hovered
}

function isUIElement(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_uielement") and v.__is_uielement
}

function UIRoot(props = {}, children = []) : UIElement(props, children) constructor {
	parent = -1
	
	x = 0
	y = 0
	
	//width = room_width
	//height = room_height
	width = UI_WIDTH
	height = UI_HEIGHT
	
	style = new StyleSheet({
		display: "block",
		position: "absolute"
	})
	
	mount = function() {
		trace("UI Root mounted btw")
	}
	
	render = function() {
		trace("UI Root render called?")
		return []
	}
}

function Div(props = {}, children = []) : UIElement(props, children) constructor {}

function Text(props = {}, children = []) : UIElement(props, children) constructor {}

function Button(props = {}, children = []) : UIClickable(props, children) constructor {}

function Sprite(props = {}, children = []) : UIElement(props, children) constructor {
	setState({ spr: 0, img: 0, xscale: 1, yscale: 1, angle: 0, color: c_white, alpha: 1 })
	// inherit
	__merge_structs(state, props)
	variable_struct_remove(state, "style")
	//setState({ spr: props.spr, img: props.img ? props.img : 0 })
	
	
	static draw = function() {
		if (state.xscale == 1 and state.yscale == 1)
			draw_sprite_stretched_ext(state.spr, state.img, x, y, width, height, state.color, state.alpha)
		else
			draw_sprite_ext(state.spr, state.img, x, y, state.xscale, state.yscale, state.angle, state.color, state.alpha)
	}
}

function UIInput(props = {}, children = []) : UIClickable(props, children) constructor {
	setState({ focused: false, value: undefined })
	
	static onFocus = function() {}
	static onUnfocus = function() {}
	
	static updateFocus = function() {
		if (mouse_check_button_pressed(mb_left)) {
			if (hovered) {
				setState({focused: true})
				onFocus()
			}
			else {
				setState({focused: false})
				onUnfocus()
			}
		}
	}
	
	static update = function() {
		updateFocus()
	}
}

function TextBox(props = {}, children = []) : UIInput(props, children) constructor {
	setState({ value: "", pointer: 0 })
	if (variable_struct_exists(props, "value"))
		setState({value: props.value})
	
	setState({ blink: true, blink_timer: 20 })
	
	max_blink_timer = 20
	max_length = 15
	
	
	
	static onFocus = function() {
		setState({ pointer: string_length(state.value) })
	}
	
	static premount = function() {
		default_style = new StyleSheet({
			border_width: 2,
			border_color: c_white,
			padding: 10,
			width: 250,
			height: 50,
			font: fNormal,
			cursor_color: c_white, // specific style variables
			cursor_alpha: 1,
			cursor_width: 3,
			color: c_white
		})
	}
	
	
	static drawCursor = function(x, y, h) {
		draw_sprite_stretched_ext(__sEmptySquare, 0, x, y, style.cursor_width, h, style.cursor_color, style.cursor_alpha)
	}
	
	static draw = function() {
		renderText(state.value, x-canvas.scroll.x, y-canvas.scroll.y)
		
		draw_set_font(style.font)
		var pre_string = string_copy(state.value, 1, state.pointer)
		
		if (state.focused and state.blink) {
			drawCursor(x + string_width(pre_string) + 2, y, string_height(state.value))
		}
	}
	
	static clear = function() {
		setState({ value: "" })
		onChange(state.value)
	}
	
	static update = function() {
		updateFocus()
		
		if (state.blink_timer == 0) { // toggle
			setState({ blink: !state.blink, blink_timer: max_blink_timer })
		}
		else { // tick down
			setState({ blink_timer: state.blink_timer - 1 })
		}
		
		if (state.focused) {
			if (keyboard_check_pressed(vk_anykey)) {
				switch(keyboard_key) {
					case vk_backspace: // erase before
						trace(state.pointer)
						
						if (state.pointer > 0) { // +1 because of gosh darn 1-indexing
							setState({ value: string_delete(state.value, state.pointer, 1) })
							setState({ pointer: state.pointer-1 })
							onChange(state.value)
						}
						break
					case vk_delete: // erase after
						trace(state.pointer)
						
						if (state.pointer < string_length(state.value)) {
							setState({ value: string_delete(state.value, state.pointer+1, 1) })
							onChange(state.value)
						}
						break
					case vk_right:
						setState({pointer: state.pointer+1})
						break
					case vk_left:
						setState({pointer: state.pointer-1})
						break
					case vk_up:
						setState({pointer: 0})
						break
					case vk_down:
						setState({pointer: string_length(state.value)})
						break
					case vk_space: // spacebar
						setState({ value: string_insert(" ", state.value, state.pointer+1) })
						setState({ pointer: state.pointer+1 })
						onChange(state.value)
						
						break
					default:
						var k = keyboard_key
						if (ord("A") <= k and k <= ord("Z")) // uppercase letters 
						or (ord("a") <= k and k <= ord("z")) // lowercase letters
						or (ord("0") <= k and k <= ord("9")) // numbers
						{
							if (string_length(state.value) < max_length) {
								setState({ value: string_insert(keyboard_lastchar, state.value, state.pointer+1) })
								setState({ pointer: state.pointer+1 }) // order matters btw
								onChange(state.value)
							}
						}
						break
				}
			}
		}
		
		// clamp the pointer
		setState({ pointer: clamp(state.pointer, 0, string_length(state.value)) })
	}
}


function UIUnwrapElements(elements) constructor {
	if !is_array(elements) {
		if isUIElement(elements) or is_string(elements) {
			return [elements]
		}
		else {
			throw "Error in UIUnwrapElements(): can't unwrap the elements (value=" + string(elements) + ")"
		}
	}
	else { // an array
		var i = 0, l = array_length(elements)
		var new_elements = []
		repeat(l) {
			var el_data = elements[i]
			if (is_array(el_data)) { // this is a tag
				var _tag = el_data[0]
				var _props = el_data[1]
				var _children = el_data[2]
				
				var el = new _tag(_props, UIUnwrapElements(_children))
				el.parent = other
				el.canvas = canvas
				
				//trace("Unwrap element of type %", el.__element_type)
			}
			else {
				el = el_data
			}
			
			new_elements[i] = el
			i++
		}
	}
		
	return new_elements
}

function isUICanvas(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_uicanvas") and v.__is_uicanvas
}

// represents the tree of elements
function UICanvas(children = []) constructor {
	__is_uicanvas = true
	
	canvas = self
	root = new UIRoot()
	
	scroll = { x: 0, y: 0 }
	
	with (root) {
		self.canvas = other
		self.children = UIUnwrapElements(children)
	}
	
	
	root._mount()
	
	static render = function() {
		//trace("canvas renderin'")
		//trace("root's")
		root._render()
	}
	
	static _recursively_update = function(element) {
		if !isUIElement(element) {
			return -1
		}
		
		//trace("imma update the element %", element.__element_type)
		element._update()
		var _children = element.get_children()
		var i = 0, l = array_length(_children)
		repeat(l) {
			var _element = _children[i]
			_recursively_update(_element)
			i++
		}
	}
	
	static update = function() {
		_recursively_update(root)
	}
	
	static addScroll = function(_x = 0, _y = 0) {
		scroll.x += _x
		scroll.y += _y
	}
	
	static resetScroll = function() {
		scroll.x = 0
		scroll.y = 0
	}
	
	array_push(global.evoui_canvases, self)
	
	static toString = function() {
		var str = "UICanvas [\n"
		str += root.toString()
		str += "\n]"
		return str
	}
}

function UICanvasDelete(canvas) {
	for(var i = 0; i < array_length(global.evoui_canvases); i++) {
		if (global.evoui_canvases[i] == canvas)
			array_delete(global.evoui_canvases, i, 1)
	}
}

///@function	loadUICanvas(path) -> UICanvas
///@returns		{UICanvas} canvas
///@description	Loads the canvas contents from an external file and returns it
///@param		{string} path
function loadUICanvas(path) {
	var data = snap_xml_format((snap_from_xml(string_from_file(path))))
	
	__convertTag = function(contents) {
		var tag_name = contents._name
		if (tag_name == "__root")
			tag_name = "UIRoot"
		
		var tag_constructor = variable_global_get(tag_name)
		var _children = []
		
		for(var i = 0; i < array_length(contents._children); i++) {
			_children[i] = __convertTag(contents._children[i])
		}
		if (contents._text != "")
			array_push(_children, contents._text)
		
		//show_message(tag_name)
		//show_message(tag_constructor)
		//var tag = new tag_constructor(contents._attr, _children)
		//return tag
		return [tag_constructor, contents._attr, _children ]
	}
	
	var ans = []
	for(var i = 0; i < array_length(data._children); i++)
		ans[i] = __convertTag(data._children[i])
	
	var canvas = new UICanvas(ans)
	return canvas
}


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

///@function	StyleSheet(style, [default_style]) -> StyleSheet
///@param		{struct} style
///@param		{struct} [default_style]
function StyleSheet(style, default_style = {}) constructor {
	__is_stylesheet = true
	
	display = "block" // "inline" | "block" ("flex" coming soon)
	position = "relative" // "relative" | "absolute"
	
	color = c_black
	font = -1
	
	bg_color = c_black
	bg_alpha = 0
	bg_sprite = -1 // sprite index
	bg_image = 0 // image index
	
	x = undefined
	y = undefined
	width = undefined
	height = undefined
	
	padding = new UIPadding()
	border = new UIBorder()
	margin = new UIMargin()
	
	
	
	static var_setter = function(s, var_name, var_value) {
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
				margin.right = var_value
				break
			case "margin_top":
			case "marginTop":
				margin.top = var_value
				break
			case "margin_left":
			case "marginLeft":
				margin.left = var_value
				break
			case "margin_bottom":
			case "marginBottom":
				margin.bottom = var_value
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
				break
			case "border_width":
			case "borderWidth":
				border.right = var_value
				border.top = var_value
				border.left = var_value
				border.bottom = var_value
				break
			case "border_right":
			case "borderRight":
				border.right = var_value
				break
			case "border_top":
			case "borderTop":
				border.top = var_value
				break
			case "border_left":
			case "borderLeft":
				border.left = var_value
				break
			case "border_bottom":
			case "borderBottom":
				border.bottom = var_value
				break
			
			case "border_color":
			case "borderColor":
			case "border_colour":
			case "borderColour":
				border.color = var_value
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
				break
			case "padding_right":
			case "paddingRight":
				padding.right = var_value
				break
			case "padding_top":
			case "paddingTop":
				padding.top = var_value
				break
			case "padding_left":
			case "paddingLeft":
				padding.left = var_value
				break
			case "padding_bottom":
			case "paddingBottom":
				padding.bottom = var_value
				break
			
			#endregion
			#region Background
			
			case "bg_color":
				bg_color = var_value
				bg_alpha = 1
				break
			
			#endregion
			
			default:
				variable_struct_set(self, var_name, var_value)
				break
		}
		}
	}
	
	// inherit the argument
	__merge_structs(self, default_style, var_setter)
	__merge_structs(self, style, var_setter)
}

///@function	isStyleSheet(value) -> bool
///@param		{any} value
///@returns		{bool} result
function isStyleSheet(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_stylesheet") and v.__is_stylesheet
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