extends VBoxContainer

onready var masterVolumeSlider = get_node("MarginContainer/ScrollContainer/VBoxContainer/GeneralVolumeContainer/MarginContainer/HBoxContainer/General")
onready var musicVolumeSlider = get_node("MarginContainer/ScrollContainer/VBoxContainer/MusicVolumeContainer/MarginContainer/HBoxContainer/Music")
onready var sfxVolumeSlider = get_node("MarginContainer/ScrollContainer/VBoxContainer/SFXVolumeContainer/MarginContainer/HBoxContainer/SFX")
onready var exitCheckBox = get_node("MarginContainer/ScrollContainer/VBoxContainer/FullscreenContainer/MarginContainer/CheckButton")
onready var languageMenu = get_node("MarginContainer/ScrollContainer/VBoxContainer/LanguageContainer/MarginContainer2/HBoxContainer/OptionButton")
var lagunagesIndex = ["es", "en"]

func _input(event):
	if event.is_action_released("ui_cancel"):
		if get_tree().change_scene_to(Preloader.scenes_GameMode) != OK: print ("error changing scene")


func get_locale():
	var locale = TranslationServer.get_locale()
	if lagunagesIndex.has(locale):
		return locale
	var splitted = locale.split("_", false)[0]
	if lagunagesIndex.has(splitted):
		return splitted
	splitted = locale.split("-", false)[0]
	if lagunagesIndex.has(splitted):
		return splitted
	return "es"


func _ready():
	get_node("ControlsMargin/Controls/MarginContainer/HBoxContainer/TextureRect3").texture = GameInput.get_button_icon_image("move")
	get_node("ControlsMargin/Controls/MarginContainer2/HBoxContainer/TextureRect3").texture = GameInput.get_button_icon_image("accept")
	get_node("ControlsMargin/Controls/MarginContainer3/HBoxContainer/TextureRect3").texture = GameInput.get_button_icon_image("back")
	masterVolumeSlider.grab_focus()
	load_settings()

func load_settings():
	masterVolumeSlider.value = Music.get_volume("Master")
	musicVolumeSlider.value = Music.get_volume("Music")
	sfxVolumeSlider.value = Music.get_volume("SFX")
	exitCheckBox.pressed = OS.window_fullscreen
	languageMenu.selected = lagunagesIndex.find(get_locale())


func _on_General_value_changed(value):
	Music.set_volume("Master", value)
	Settings.change_value("generalVolume", value)


func _on_Music_value_changed(value):
	Music.set_volume("Music", value)
	Settings.change_value("musicVolume", value)


func _on_SFX_value_changed(value):
	Music.set_volume("SFX", value)
	Settings.change_value("sfxVolume", value)


func _on_CheckButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	Settings.change_value("fullScreen", button_pressed)


func _on_OptionButton_item_selected(index):
	TranslationServer.set_locale(lagunagesIndex[index])
	Settings.change_value("language", lagunagesIndex[index])


func _on_DefaultSettings_pressed():
	Settings.default_settings()
	load_settings()
