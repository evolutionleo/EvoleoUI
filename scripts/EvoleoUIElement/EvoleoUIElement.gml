// TODO: add center halign/valign to the layout engine

function UIElement(props = {}, children = []) constructor {
	__is_uielement = true
	__element_type = instanceof(self)
	
	//trace("i am a", __element_type)
	
	id = undefined
	class = ""
	
	mounted = false
	
	self.children = children
	self.props = props
	
	parent = undefined
	canvas = undefined
	
	x = 0
	y = 0
	
	//width = 100
	//height = 100
	width = undefined
	height = undefined
	
	static getWidth = function() {
		if (is_undefined(width)) calculateWidth()
		return width
	}
	
	static getHeight = function() {
		if (is_undefined(height)) calculateHeight()
		return height
	}
	
	static calculateWidth = function() {
		width = 0
		
		if (!is_undefined(style.width)) {
			width = style.width
		}
		//else if (!is_undefined(style.min_width)) {
			
		//}
		else {
			// TODO: support dynamic width
			width = 100
		}
		
		
		if (!is_undefined(style.min_width))
			width = max(width, style.min_width)
		
		if (!is_undefined(style.max_width))
			width = min(width, style.max_width)
		
		
		return width
	}
	
	static calculateHeight = function() {
		height = 0
		
		if (style.height != undefined) {
			height = style.height
			return height
		}
		
		
		height += style.padding.top
		
		self.forEach(function(child, i, parent) {
			if (is_string(child)) { // calculate string_height() with the parent's font
				draw_get()
				draw_set_font(parent.style.font)
				height += string_height(child)
				draw_reset()
			}
			else if isUIElement(child) {
				if (child.style.display == "none")
					return;
				
				height += child.style.margin.top
				height += child.getHeight()
				height += child.style.margin.bottom
			}
			else { /* wtf */ }
		})
		
		height += style.padding.bottom
		
		if (!is_undefined(style.min_height))
			height = max(height, style.min_height)
		
		if (!is_undefined(style.max_height))
			height = min(height, style.max_height)
		
		//show_message(stf("Calculated height: %", height))
	}
	
	// read-only: where the element is actually rendered
	draw_pos = { x: 0, y: 0 }
	
	//style = new Style({})
	style = undefined
	default_style = undefined
	
	state = {}
	
	///@function	setState(state)
	///@desc		sets some state variables
	///@param		{struct} state
	static setState = function(_state) {
		__merge_structs(state, _state)
	}
	
	static update = function() {}
	
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
		draw_set_align(style.halign, style.valign)
		
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
	
	// the core of the layout engine
	static _render = function(originX = 0, originY = 0) {
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
			repeat(array_length(rendered)) {
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
		
		var i = 0
		repeat(array_length(rendered)) {
			var _el = rendered[i]
			_el.canvas = canvas
			_el.parent = self
			
			//trace("% mounted? %", _el.__element_type, _el.mounted)
			
			if (!_el.mounted)
				_el._mount()
			i++
		}
		
		
		var _torender = get_children()
		
		var i = 0
		repeat(array_length(_torender)) {
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
						if (pointerX + el.width + el.style.margin.left > originX + width - style.padding.right) {
							pointerX = originX
							
							pointerY += el.style.margin.top
							pointerY += el.height
							pointerY += el.style.margin.bottom
							
							el._render(pointerX, pointerY)
						}
						else {
							el._render(pointerX, pointerY)
							
							pointerX += el.style.margin.left
							pointerX += el.width
							pointerX += el.style.margin.right
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
	
	// TODO: Implement these for UIElement and UICanvas
	static forEach = function(func) {
		var ch = get_children()
		for(var i = 0; i < array_length(ch); i++) {
			var child = ch[i]
			func(child, i, self)
			if (isUIElement(child))
				child.forEach(func)
		}
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
			
			_style = new Style(default_style)
			
			if (!is_undefined(style)) {
				__merge_structs(_style, style/*, _style.var_setter*/)
			}
			
			style = _style
			
			applyStyles()
			
			//show_message(stf("assigning styles: %", style))
		
			if (style.x != undefined)
				x = style.x
			if (style.y != undefined)
				y = style.y
			
			
			// mount the children
			var i = 0, l = array_length(children)
			repeat(l) {
				var child = children[i]
				
				if isUIElement(child) {
					child._mount()
				}
				i++
			}
		
			calculateWidth()
			calculateHeight()
			
			mount()
			
			mounted = true
		}
	}
	
	applied_styles = []
	static applyStyles = function() {
		applied_styles = []
		// collect all the matching styles from stylesheets
		var i = 0
		//trace("there are % styles in the sheet.", array_length(global.evoui_stylesheets))
		repeat(array_length(global.evoui_stylesheets)) {
			var stylesheet = global.evoui_stylesheets[i]
			
			var _styles = stylesheet.styles, j = 0
			repeat(array_length(_styles)) {
				var _style = _styles[j]
				//trace("trying to match style w/ selector: " + string(_style.selector.selector))
				if (_style.selector.matches(self)) {
					//trace("match!")
					//trace("the priority of this one is:", _style.getPriority())
					array_push(applied_styles, _style)
				}
				j++
			}
			i++
		}
		
		// sort the styles in order of priority
		array_sort(applied_styles, function(s1, s2) { return s1.getPriority() - s2.getPriority() })
		
		// apply them!
		var i = 0
		repeat(array_length(applied_styles)) {
			style.mergeStyle(applied_styles[i])
			i++
		}
	}
	//applyStyles() // moved to _mount()
	
	
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

function isUIElement(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_uielement") and v.__is_uielement
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
		var i = 0
		var new_elements = []
		repeat(array_length(elements)) {
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
