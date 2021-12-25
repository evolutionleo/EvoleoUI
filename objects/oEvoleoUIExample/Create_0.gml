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

var sheet = new StyleSheet([ global_style, text_style, level_style, class_style, div_style ])

//styles = new StyleSheet()

canvas = loadUICanvas("Canvases/test_canvas.xml")

show_message(canvas)
//show_message(array_length(canvas.root.children[0]))