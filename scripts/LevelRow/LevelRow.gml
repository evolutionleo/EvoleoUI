function LevelRow(props = {}, children = []) : UIClickable(props, children) constructor {
	setState({ img: 0 })
	trace("haha img is 0 again")
	
	premount = function() {
		default_style = new Style({
			//width: 420,
			//height: 140,
			margin_left: 50,
			margin_bottom: 50,
			padding: 20,
			border_width: 4,
			border_color: c_white,
		})
	}
	
	//draw = function() {
	//	draw_set_font(fNormal)
	//	draw_text(x, y - 20, string(state))
	//}
	
	
	playButton = function() {
		if (state.img == 0)
			setState({img: 1})
		else
			setState({img: 0})
		//show_debug_message(state)
		rerender()
	}
	
	static render = function() {
		//trace("I'm being rendered with img=%", state.img)
		return [
			[Div, {style: {
				position: "relative",
				display: "inline",
				//width: 420+20*2,
				//height: 140
			}}, [
			  [Div, {style: { position: "relative", display: "block", /*width: 300-20, height: 100-20*2*/ }}, [
				[Text, {style: {font: fH4, color: c_white}, /*width: 300-20, height: 80-20*/}, [props.level_name]],
				[Text, {style: {font: fNormal, color: c_white}, /*width: 300-20, height: 60-20*/}, ["by: " + string(props.author)]]
			  ]],
			  [Button, {
					onClick: playButton,
					onHover: function() {
						//trace("hover button lol")
					},
					//draw: function() {
					//	draw_text(x, y-10, string(self.state))
					//},
					style: {
						/*width: 120-20,
						height: 140-20*2,
						*/
						//padding: 10,
						border_width: 4,
						border_color: c_white
					}
				}, [
					[Sprite, {
						spr: sIcon,
						img: state.img,
						style: {
							width: 120-20,
							height: 140-20*2,
						}
					}, []]
			    ]]
			]]
		]
	}
}