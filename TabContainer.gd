extends TabContainer


onready var control = $".."
func _ready() -> void:
# warning-ignore:return_value_discarded
	get_tree().connect("files_dropped", self, "open_files")
# warning-ignore:return_value_discarded
	Gotm.connect("files_dropped", self, "open_file")


func _process(_delta: float) -> void:
	tabs_visible = not get_children().size() == 1

func open_files(dragged_files: PoolStringArray, _screen):
	var files: PoolStringArray = correct_file_extension(dragged_files)
	for file in files:
		var tab = Tabs.new()
		var text_area = TextEdit.new()
		tab.name = file
		tab.tab_close_display_policy = Tabs.CLOSE_BUTTON_SHOW_ALWAYS
		text_area.text = load_file(file)
		add_child(tab)
		var text_area_script = load("res://TextEdit.gd").instance()
		text_area.set_script(text_area_script)
		text_area.anchor_right = 1
		text_area.anchor_bottom = 1
		text_area.connect("cursor_changed", control, "_on_TextEdit_cursor_changed", [text_area.cursor_get_column(), text_area.cursor_get_line()])
		text_area.connect("text_changed", control, "_on_TextEdit_text_changed", [text_area.text])
		tab.add_child(text_area)

func correct_file_extension(files: PoolStringArray) -> PoolStringArray:
	var bad_extensions: PoolStringArray = [
		"png",
		"jpg",
		"jpeg",
		"exr",
		"doc",
		"dll",
		"exe",
		"pdf",
	]
	var correct_files: PoolStringArray = []
	for file in files:
		if not file.get_extension() in bad_extensions:
			correct_files.append(file)
	return correct_files

func load_file(file: String):
	var f = File.new()
	f.open(file, File.READ)
	return f.get_as_text()
