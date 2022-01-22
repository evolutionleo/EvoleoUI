/// @desc

//canvas = new UICanvas()
//exit

//var div_wrapper = new Style({
//	width: room_width,
//	height: room_height,
//	display: "block",
//})

//var div_style = new Style("Div", {
//		color: c_white,
//		bg_color: c_red,
//		bg_alpha: 1,
//})

//var spr_style = new Style("Sprite", {
//	width: 70,
//	height: 70,
//	//x: 200,
//	//y: 200,
//})

//var spr_wrapper = new Style(".wrapper", {
//	width: 200,
//	height: 200,
//})


//canvas = new UICanvas([
//	[Div, {style: div_style}, ["text"]],
//	[Div, {style: spr_wrapper}, [
//		[Sprite, {style: spr_style, spr: sThing, img: 0}, []]
//	]],
//	[Div, {height: 600}, [
//		[LevelRow, {level_name: "Level 1", author: "Evoleo", width: 400, height: 150}, []],
//		[LevelRow, {level_name: "Level 2", author: "aGuy2005", width: 400, height: 150}, []],
//		[LevelRow, {level_name: "Level 3", author: "SomeDude1337", width: 400, height: 150}, []]
//	]],
//	[TextBox, {value: "string", onChange: function(value) { trace("new value: %", value) }}, []]
//])

//var global_style = new Style("*", {
//	width: 200,
//	height: 50,
//	bg_color: c_blue
//})

var global_style = new Style("*", {
	
})

var text_style = new Style("Text", {
	color: c_white,
	//marginLeft: 10
})

var level_style = new Style("LevelRow", {
	margin: 20
})

var class_style = new Style(".text-haha", {
	font: fH1
})

var div_style = new Style("Div", {
	color: c_red
})

var container_style = new Style(".container", {
	padding: 15
})
container_style.apply()


var id_style = new Style("#specific-element", {
	color: c_lime
})
id_style.g()

var inline_style = new Style(".inline", {
	display: "inline"
})
inline_style.g()

var sheet = new StyleSheet([ global_style, text_style, level_style, class_style, div_style ])


// add the utility classes for some of the colors
var COLORS = ["red", "aqua", "blue", "lime", "white", "black", "dkgray", "ltgray", "orange", "purple", "silver"]
//var colors_sheet = new StyleSheet()
for(var i = 0; i < array_length(COLORS); i++) {
	var color = COLORS[i]
	var color_style = new Style("."+color, {
		color: variable_global_get("c_" + color)
	}).g()
	//colors_sheet.addStyle(color_style)
}

//styles = new StyleSheet()

canvas = loadUICanvas("Canvases/test_canvas.xml")

//show_message(canvas.toString())
//show_message(array_length(canvas.root.children[0]))