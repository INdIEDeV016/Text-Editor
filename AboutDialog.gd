extends WindowDialog


onready var tab_container = $TabContainer
onready var info = tab_container.get_node("License/Info")

func _on_CreatedBy_meta_clicked(meta):
	if meta == "dev":
		tab_container.current_tab = 2


func _on_Info_meta_clicked(meta):
	var err = OS.shell_open(meta)
	if err != OK:
		print("Couldn't open link")


func _on_Info_meta_hover_ended(_meta):
	pass # Replace with function body.


func _on_Info_meta_hover_started(_meta):
	pass


func _on_RichTextLabel_meta_clicked(meta):
	if meta == "license":
		tab_container.current_tab = 3
