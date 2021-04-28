#Programming Language = GDScript (similar to Python)

extends Control

var app_name: String = ProjectSettings.get_setting("application/config/name")
var current_file = "Untitled"
var is_saved: String = ""
var _path = String(OS.get_executable_path())
onready var version = get_node("Dialogs/AboutDialog/Version").text
onready var arguments = Array(OS.get_cmdline_args())
onready var text_area = $TabContainer/Untitled/TextEdit

var dark_theme = preload("res://Themes/DarkTheme.theme")
var light_theme = preload("res://Themes/LightTheme.theme")
var current_theme = "light"

signal script_mode
signal open_dialog

var current_text: String
var new_text: String
var info: String = "" setget set_info

onready var info_label = $InfoContainer/Info

func _ready():
	OS.min_window_size = Vector2(300, 50)
	CustomSettings.load_settings()
	
	change_theme(get_setting("theme"))
	
	if not CustomSettings.settings["is_whats_new_seen"]:# or arguments[1]:
		emit_signal("open_dialog", $Dialogs/AboutDialog)
		save_setting("is_whats_new_seen", true)
	
	text_area.grab_focus()
	get_tree().set_auto_accept_quit(false)
	
	current_text = ""
	update_window_title()
	for item in ["File","Edit","View","Format","Help"]:
		get_node("MenuBar/" + item).get_popup().connect("id_pressed", self, "_on_item_" + item + "_pressed")
	
	$InfoContainer/AnimationPlayer.playback_active = true
	info_label.add_color_override("font_color", Color.orange)
	self.info = ""
	
	$Dialogs/OpenFileDialog.current_dir = OS.get_system_dir(2)
	$Dialogs/SaveFileDialog.current_dir = OS.get_system_dir(2)
	
	var err = connect("script_mode", text_area, "highlight_syntaxes")
	if err != OK:
		print("Couldn't start Script Mode")
	
	if not OS.get_cmdline_args().empty():
		open_file(OS.get_cmdline_args()[0])
		self.info = OS.get_cmdline_args()[0]
	self.info = version


var window_title
func update_window_title():
	window_title = current_file + is_saved
	OS.set_window_title(app_name + " - " + window_title)


func new_file():
	current_file = "Untitled"
	is_saved = ""
	update_window_title()
	text_area.text = ""
	self.info = "New File created!"

func save_file():
	var path = current_file
	if path == "Untitled" or path == "Untitled(*)":
		emit_signal("open_dialog", $Dialogs/SaveFileDialog)
	else:
		mouse_default_cursor_shape = Control.CURSOR_BUSY
		var f = File.new()
		f.open(path, 2)
		f.store_string(text_area.text)
		current_text = new_text
		f.close()
		is_saved = ""
		update_window_title()
		self.info = "Saved!"
		mouse_default_cursor_shape = Control.CURSOR_ARROW

func open_file(path):
	if path[0] is GotmFile:
		var content = path[0].data.get_string_from_utf8()
		current_file = path[0]
		update_window_title()
		self.info = "Opened file %s" % path
		text_area.text = content
	else:
		print(path)
		var f = File.new()
		f.open(path, 1)
		text_area.text = f.get_as_text()
		current_text = text_area.text
		f.close()
		current_file = path
		_path = path
		is_saved = ""
		update_window_title()
		self.info = "File opened from this location - " + current_file


func _on_item_File_pressed(id):
	var item_name = $MenuBar/File.get_popup().get_item_text(id)
	match item_name:
		"New":
			new_file()
		"Open":
			if OS.has_feature("pc"):
				emit_signal("open_dialog", $Dialogs/OpenFileDialog)
			if OS.has_feature("web"):
				var path = yield(Gotm.pick_files([".txt"], true), "completed")
				print(path)
				open_file(path)
		"Save":
			save_file()
		"Save As...":
			if OS.has_feature("web"):
				if text_area.text != "":
					var gotm_file = GotmFile.new()
					gotm_file.data = text_area.text.to_utf8()
					gotm_file.download()
				else:
					print("The file is empty, can't download it")
					self.info = "The file is empty, can't download it"
			else:
				emit_signal("open_dialog", $Dialogs/SaveFileDialog)
		"Quit":
			if text_area.text != "" and current_file == "Untitled":
				emit_signal("open_dialog", $Dialogs/SaveDialog)
			else:
				if is_saved.empty():
					get_tree().quit()
				else:
					emit_signal("open_dialog", $Dialogs/SaveDialog)


func _on_item_Edit_pressed(id):
	var item_name = $MenuBar/Edit.get_popup().get_item_text(id)
	match item_name:
		"Undo":
			text_area.undo()
		"Redo":
			text_area.redo()
		"Cut":
			text_area.cut()
		"Copy":
			text_area.copy()
		"Paste":
			text_area.paste()
		"Time Stamp":
			var time = OS.get_time()
			text_area.insert_text_at_cursor(String(time["hour"])+":"+String(time["minute"])+":"+String(time["second"]))
		"Find/Replace":
			emit_signal("open_dialog", $Dialogs/FindReplaceDialog)
		"Preferences":
			emit_signal("open_dialog", $Dialogs/PreferencesDialog)


func _on_item_View_pressed(id):
	var item_name = $MenuBar/View.get_popup().get_item_text(id)
	match item_name:
		"Dark Mode":
			if $MenuBar/View.get_popup().is_item_checked(0):
				change_theme("light")
				save_setting("theme", "light")
			else:
				change_theme("dark")
				save_setting("theme", "dark")
		"Script Mode":
			if $MenuBar/View.get_popup().is_item_checked(1):
				$MenuBar/View.get_popup().set_item_checked(1, false)
				set_script_mode(false)
			else:
				$MenuBar/View.get_popup().set_item_checked(1, true)
				set_script_mode(true)
		"Custom Theme   >":
			emit_signal("open_dialog", $Dialogs/CustomThemeDialog)

onready var godot_logo = $"Dialogs/AboutDialog/TabContainer/About App/Godot_logo"
func change_theme(_theme):
	if _theme == "light":                           #Light theme params
		$ColorRect.color = Color(0.701961, 0.8, 1)
		godot_logo.self_modulate = Color(0.9,0.9,0.9)
		theme = light_theme
		$MenuBar/View.get_popup().set_item_checked(0, false)
		current_theme = "light"
		save_setting("theme", "light")
	elif _theme == "dark":                          #Dark theme params
		$ColorRect.color = Color(0.15, 0.17, 0.23)
		godot_logo.self_modulate = Color(1.2, 1.2, 1.2)
		theme = dark_theme
		$MenuBar/View.get_popup().set_item_checked(0, true)
		current_theme = "dark"
		save_setting("theme", "dark")

func set_script_mode(_bool):
	if _bool == true:
		$Dialogs/OpenFileDialog.set_filters(PoolStringArray(["*.txt ; Text Files", "*.gd ; GDScript Files"]))
		$Dialogs/SaveFileDialog.set_filters(PoolStringArray(["*.txt ; Text Files", "*.gd ; GDScript Files"]))
		text_area.show_line_numbers = true
		emit_signal("script_mode", true)
		if current_theme == "dark":
			text_area.theme = load("res://Themes/Script Mode/ScriptModeDark.theme")
		elif current_theme == "light":
			text_area.theme = load("res://Themes/Script Mode/ScriptModeLight.theme")
	elif _bool == false:
		$Dialogs/OpenFileDialog.set_filters(PoolStringArray(["*.txt ; Text Files"]))
		$Dialogs/SaveFileDialog.set_filters(PoolStringArray(["*.txt ; Text Files"]))
		emit_signal("script_mode", false)
		text_area.theme = null
		text_area.show_line_numbers = false
		text_area.clear_colors()

func _on_item_Format_pressed(id):
	var item_name = $MenuBar/Format.get_popup().get_item_text(id)
	match item_name:
		"Word Wrap":
			if text_area.wrap_enabled == false:
				text_area.wrap_enabled = true
				$MenuBar/Format.get_popup().set_item_checked(0, true)
				text_area.minimap_width = 100
			else:
				text_area.wrap_enabled = false
				$MenuBar/Format.get_popup().set_item_checked(0, false)
	
		"Minimap     >":
			emit_signal("open_dialog", $Dialogs/MinimapDialog)


func _on_item_Help_pressed(id):
	var item_name = $MenuBar/Help.get_popup().get_item_text(id)
	match item_name:
		"About":
			emit_signal("open_dialog", $Dialogs/AboutDialog)
		"Check For Updates...":
			if is_saved.empty():
				open_update_manager()
			else:
				emit_signal("open_dialog", $Dialogs/WarningDialog)


func _on_Link_pressed():
	var err = OS.shell_open("https://www.godotengine.org")
	if err != OK:
		print("Couldn't open Website")


func _on_OpenFileDialog_file_selected(path):
	open_file(path)

func _on_SaveFileDialog_file_selected(path):
	print(path)
	var f = File.new()
	f.open(path, 2)
	f.store_string(text_area.text)
	current_text = text_area.text
	f.close()
	current_file = path
	is_saved = ""
	update_window_title()
	self.info = "Saved at location - " + current_file
	
	
func _on_TextEdit_text_changed(text=""):
	new_text = text_area.text if text.empty() else text
	if current_text != new_text:
		is_saved = "(*)"
	else:
		is_saved = ""
	update_window_title()

func _on_TextEdit_cursor_changed(col = 0, line = 0):
	var column_number = text_area.cursor_get_column() + 1 if col == 0 else col
	var line_number = text_area.cursor_get_line() + 1 if line == 0 else line
	$InfoContainer/LineNum.text = String(line_number)
	$InfoContainer/ColumnNum.text = String(column_number)


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		text_area.minimap_draw = true
	else:
		text_area.minimap_draw = false

func _on_SpinBox_value_changed(value):
	text_area.minimap_width = value


func _on_SaveButton_pressed():
	$Dialogs/SaveDialog.visible = false
	if not current_file == _path:
		emit_signal("open_dialog", $Dialogs/SaveFileDialog)
	else:
		save_file()
		get_tree().quit()

func open_update_manager():
	if OS.has_feature("64"):
		var _pid = OS.execute(OS.get_executable_path().get_base_dir() + "/Updater-64.exe", [OS.get_process_id(), _path, version], false)
	elif OS.has_feature("32"):
		var _pid = OS.execute(OS.get_executable_path().get_base_dir() + "/Updater.exe", [OS.get_process_id(), _path, version], false)
	get_tree().quit()

func _on_DontSaveButton_pressed():
	get_tree().quit()


func _on_CancelButton_pressed():
	$Dialogs/SaveDialog.visible = false


func set_info(info_text):
	print(info_text)
	info_label.text = info_text
	$InfoContainer/AnimationPlayer.play("Info Label")
	$InfoContainer/AnimationPlayer.seek(0, true)



func save_setting(setting, value):
	CustomSettings.settings[setting] = value
	CustomSettings.save_settings()

func check_setting(setting, value):
	if CustomSettings.settings[setting] == value:
		return true
	else:
		return false

func get_setting(setting):
	var set = CustomSettings.settings
	return set[setting]

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if is_saved == "(*)":
			emit_signal("open_dialog", $Dialogs/SaveDialog)
		else:
			CustomSettings.save_settings()
			get_tree().quit()
