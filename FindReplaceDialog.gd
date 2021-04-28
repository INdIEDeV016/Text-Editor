extends WindowDialog


onready var text_edit = $"../../TabContainer/Untitled/TextEdit"
onready var find = $VBoxContainer2/FindEdit
onready var replace = $VBoxContainer2/ReplaceEdit
onready var replace_button = $VBoxContainer/ReplaceButton
onready var find_button = $VBoxContainer/FindButton
onready var replace_mode = $VBoxContainer2/ReplaceMode
onready var options = $MenuButton

var search_flag: int

func _ready():
	var err = options.get_popup().connect("id_pressed", self, "set_search_flag")
	if err != OK:
		print("Can't choose options")
	
	replace_mode.pressed = false

var once: bool = false
var res_column: int
var res_line: int
func find_word(what: String, flags: int):
	var result
	if once:
		result = text_edit.search(what, flags, res_line, res_column)
	else:
		result = text_edit.search(what, flags, 0, 0)
		once = true
	var word: String
	if result.size() > 0:
		res_line = result[TextEdit.SEARCH_RESULT_LINE]
		res_column = result[TextEdit.SEARCH_RESULT_COLUMN]
		print("Word found at line %d and column %d" % [res_line + 1, res_column + 1])
		text_edit.cursor_set_line(res_line, true, false)
		text_edit.cursor_set_column(res_column + 1)
		word = text_edit.get_word_under_cursor()
		var word_length = word.length()
		if replace_mode.pressed:
			text_edit.select(res_line, res_column, res_line, res_column + word_length)
			text_edit.text.replace(text_edit.get_selection_text(), replace.text)
		text_edit.select(res_line, res_column, res_line, res_column + word_length)
		text_edit.cursor_set_column(res_column + word_length)
	else:
		$"../..".info = "Couldn't find %s" % [find.text]


func set_search_flag(id):
	var item_name = options.get_popup().get_item_text(id)
	match item_name:
		"Match Upper-Case or Lower_Case":
			if not options.get_popup().is_item_checked(0):
				search_flag = TextEdit.SEARCH_MATCH_CASE
				options.get_popup().set_item_checked(0, true)
			else:
				search_flag = 0
				options.get_popup().set_item_checked(0, false)
		"Individual Words":
			if not options.get_popup().is_item_checked(1):
				search_flag = TextEdit.SEARCH_WHOLE_WORDS
				options.get_popup().set_item_checked(1, true)
			else:
				search_flag = 0
				options.get_popup().set_item_checked(1, false)
		"Match Backwards":
			if not options.get_popup().is_item_checked(2):
				search_flag = TextEdit.SEARCH_BACKWARDS
				options.get_popup().set_item_checked(2, true)
			else:
				search_flag = 0
				options.get_popup().set_item_checked(2, false)

func _on_OKButton_pressed():
	hide()


func _on_ReplaceMode_toggled(button_pressed: bool):
	replace.editable = button_pressed
	replace_button.disabled = not button_pressed


func _on_FindButton_pressed():
	find_word(find.text, search_flag)


func _on_ReplaceButton_pressed():
	find_word(find.text, search_flag)
