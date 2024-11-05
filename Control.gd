extends Control


func load_json_data(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedFile = JSON.parse_string(dataFile.get_as_text())
		if parsedFile is Dictionary :
			return parsedFile
		else:
			print("ERREUR : JSON")

func label_treatment(dialog, jsonPath):
	remove_buttons()
	var jsonData : Dictionary = load_json_data(jsonPath)
	get_node("Label").text = jsonData[dialog]["text"]
	add_buttons(dialog, jsonData, jsonPath)


	
func add_buttons(dialog, jsonData, jsonPath):
	if("answers" not in jsonData[dialog] or "answers" not in jsonData[dialog]):
		return
	var answers = jsonData[dialog]["answers"]
	var response = jsonData[dialog]["response"]
	for i in range(len(answers)):
		var new_button = Button.new()
		new_button.text = answers[i]
		new_button.set_meta("Dialog", response[i])
		new_button.set_meta("json_path", jsonPath)
		
		new_button.pressed.connect(self._button_pressed.bind(new_button))
		
		get_node("VBoxContainer").add_child(new_button)
	
func remove_buttons():
	for child in get_node("VBoxContainer").get_children():
		get_node("VBoxContainer").remove_child(child)
	
	
func _button_pressed(arg):
	label_treatment(arg.get_meta("Dialog"),arg.get_meta("json_path"))

func _on_button_pressed():
	label_treatment($Button.get_meta("Dialog"),$Button.get_meta("json_path"))
	
func _on_button_2_pressed():
	label_treatment($Button.get_meta("Dialog"), $Button2.get_meta("json_path"))
	
