extends WindowDialog

onready var tab = $Body/HSplitContainer/TabContainer
onready var preview_label = $Body/HSplitContainer/TabContainer/VBoxContainer2/PanelContainer2/ScrollContainer/VBoxContainer/Preview
onready var font_size_roller = $Body/HSplitContainer/TabContainer/VBoxContainer2/HBoxContainer2/VBoxContainer/FontSize

func _on_PreferencesDialog_about_to_show():
	$HSplitContainer/PreferencesList.popup()



func _on_PreferencesList_item_selected(index):
	tab.current_tab = index



func _on_FontSizeList_item_selected(index):
	$"../../InfoContainer".zoom = 100
	var font_sizes = [7,8,9,10,11,12,14,16,18,20,24,28,36]
	var _range = range(12+1)
	if index == _range[index]:
		preview_label.get_font("font").size = font_sizes[index]
		font_size_roller.value = font_sizes[index]

var fonts = PoolStringArray([
	"Lato",
	"Lobster",
	"Lora",
	"Quicksand",
	"Roboto",
	"Roboto_Mono",
	"PUBG",
	])
func _on_FontList_item_selected(index):
	var path = "res://Fonts/"
	var _range = range(6+1)
	if index == _range[index]:
		preview_label.get_font("font").font_data = load(path + fonts[index]+"/"+fonts[index]+"-Regular.ttf")



func _on_FontSize_value_changed(value):
	preview_label.get_font("font").size = value


func _on_FontTypeList_item_selected(_index):
	pass # Replace with function body.
