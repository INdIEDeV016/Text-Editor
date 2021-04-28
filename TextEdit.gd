extends TextEdit


onready var control = $"../.."


func calculate_zoom_percentage(zoom, _max):
	var amount = zoom * 100 / _max
	get_font("font").size = clamp(amount, 10, 100)

func highlight_syntaxes(_bool):
	pass
	if _bool:
		add_color_region("$",",", Color(0.384314, 0.752941, 0.34902))
		add_color_region('"','"', Color(1, 0.92549, 0.631373))
		add_color_region("'","'", Color(1, 0.92549, 0.631373))
		add_color_region('#','', Color(0.462745, 0.47451, 0.509804))
		add_color_region('//','', Color(0.462745, 0.47451, 0.509804))
		var keywords = [
			"for",
			"in",
			"if",
			"else",
			"elif",
			"is",
			"await",
			"async",
			"def",
			"func",
			"var",
			"function",
		]
		for keyword in keywords:
			add_keyword_color(keyword, Color.indianred)
		add_keyword_color(".", Color(0.764706, 0.882353, 1))
		add_keyword_color(":", Color(0.764706, 0.882353, 1))
		add_keyword_color(",", Color(0.764706, 0.882353, 1))
		add_keyword_color("(", Color(0.764706, 0.882353, 1))
		add_keyword_color(")", Color(0.764706, 0.882353, 1))
