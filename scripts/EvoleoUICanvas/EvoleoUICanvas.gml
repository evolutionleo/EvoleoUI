global.evoui_canvases = []


// represents the tree of elements
function UICanvas(children = []) constructor {
	__is_uicanvas = true
	
	canvas = self
	root = new UIRoot()
	
	scroll = { x: 0, y: 0 }
	scroll_limit = {
		x: {
			min: 0,
			max: 99999
		},
		y: {
			min: 0, max: 99999
		}
	}
	
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
	
	static draw = function() {
		root.__draw()
	}
	
	static _recursively_update = function(element) {
		if !isUIElement(element) {
			return -1
		}
		
		//trace("imma update the element %", element.__element_type)
		element._update()
		var _children = element.get_children()
		var i = 0
		repeat(array_length(_children)) {
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
		
		clampScroll()
	}
	
	static resetScroll = function() {
		scroll.x = 0
		scroll.y = 0
		
		clampScroll()
	}
	
	static clampScroll = function() {
		scroll.x = clamp(scroll.x, scroll_limit.x.min, scroll_limit.x.max)
		scroll.y = clamp(scroll.y, scroll_limit.y.min, scroll_limit.y.max)
	}
	
	
	// TODO: Implement querySelector() and querySelectorAll()
	static querySelector = function(_selector) {
		var selector = new SimpleSelector(_selector)
		
	}
	
	static querySelectorAll = function(_selector) {
		var selector = new SimpleSelector(_selector)
		
	}
	
	// deep forEach
	static forEach = function(func, includeText = true) {
		root.forEach(func, includeText)
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
	var data = (snap_from_xml(string_from_file(path)))
	//show_message(data)
	trace(data)
	
	__convertTag = function(contents) {
		var tag_name = contents.type
		if (tag_name == "root")
			tag_name = "UIRoot"
		
		var tag_constructor = variable_global_get(tag_name)
		var _children = []
		
		if (variable_struct_exists(contents, "children")) {
			for(var i = 0; i < array_length(contents.children); i++) {
				_children[i] = __convertTag(contents.children[i])
			}
		}
		if (variable_struct_exists(contents, "text") and contents.text != "")
			array_push(_children, contents.text)
		
		if (variable_struct_exists(contents, "attributes") and contents.attributes)
			var attr = contents.attributes
		else
			attr = {}
		
		// preprocess the attributes
		var attr_names = variable_struct_get_names(attr), i = 0
		repeat(array_length(attr_names)) {
			var attr_name = attr_names[i]
			var attr_value = attr[$ (attr_name)]
			
			try { // a valid json
				var _data = json_parse(attr_value)
				attr[$ (attr_name)] = data
			}
			catch(e) { // not a valid json
				try { // a valid number
					var _val = real(attr_value)
					attr[$ (attr_name)] = _val
				}
				catch(_) { // just a string
					attr[$ (attr_name)] = attr_value
				}
			}
			
			
			i++
		}
		
		//var tag = new tag_constructor(attr, _children)
		//return tag
		
		return [tag_constructor, attr, _children ]
	}
	
	var ans = []
	for(var i = 0; i < array_length(data.children); i++)
		ans[i] = __convertTag(data.children[i])
	
	var canvas = new UICanvas(ans)
	return canvas
}


function isUICanvas(v) {
	return is_struct(v) and variable_struct_exists(v, "__is_uicanvas") and v.__is_uicanvas
}
