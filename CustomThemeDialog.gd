extends WindowDialog

onready var color_rect = $HSplitContainer/VBoxContainer2/ColorRect
onready var preview = $HSplitContainer/VBoxContainer2/ColorRect/Preview
onready var color_picker = $HSplitContainer/TabContainer/Colors/VBoxContainer/ColorPickerButton

var darkened_value: = 0.8
var lightened_value: = 0.5

func _ready():
	color_rect.color = color_picker.color

func _on_ColorPickerButton_color_changed(color):
	if $"../..".current_theme == "light":
		color_rect.color = color
		for type in ["font_color", "function_color", "caret_color", "symbol_color", "number_color"]:
			preview.add_color_override(type, color.darkened(darkened_value))
		preview.add_color_override("background_color", color.lightened(lightened_value))
	elif $"../..".current_theme == "dark":
		color_rect.color = color
		for type in ["font_color", "function_color", "caret_color", "symbol_color", "number_color"]:
			preview.add_color_override(type, color.lightened(lightened_value))
		preview.add_color_override("background_color", color.darkened(darkened_value))

var light_theme = preload("res://Themes/LightTheme.theme")
var window_stylebox = light_theme.get_stylebox("panel", "WindowDialog")
var menu_button_hover = light_theme.get_stylebox("hover", "MenuButton")
var menu_button_pressed = light_theme.get_stylebox("pressed", "MenuButton")
func apply_theme():
	var color = color_picker.color
	var _theme = Theme.new()
	_theme.copy_theme(light_theme)
	for type in ["background_color", "font_color", "function_color", "caret_color", "symbol_color", "number_color"]:
		_theme.set_color(type, "TextEdit", preview.get_color(type, "TextEdit"))
		
	_theme.set_color("font_color", "Label", preview.get_color("font_color", "TextEdit"))
	
	var window_panel = _theme.get_stylebox("panel", "WindowDialog")
	window_panel.bg_color.h = color.h
	window_panel.bg_color.s = color.s
	window_panel.bg_color.v = color.v
	_theme.set_stylebox("panel", "WindowDialog", window_panel)
	
	menu_button_hover.bg_color = color.darkened(0.5)
	
	return _theme

func _on_ApplyButton_pressed():
	$"../../ColorRect".color = color_picker.color
	$"../..".theme = apply_theme()


func _on_OKButton_pressed():
	hide()


func _on_ResetButton_pressed():
	pass
#	var menu_button_hover = menu_button_hover
#	var menu_button_pressed = menu_button_pressed
