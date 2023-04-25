extends Node

var gamepadDeadzone = 0.5
var playersNumber = 0
var usingTouch = false
#  Input types
#    -1 = Unsigned
#     0 = Keyboard
#     1 = Gamepads (only Dualshock tested)
#     2 = Touch (for mobile)

#  Input index
#    -1 = Unsigned
#     X = Index

var usedGamepads = []
var playersType = [0, -1, -1, -1]
var playersIndex = [0, -1, -1, -1]
var isPlaying = [true, false, false, false]

func new_player(index, inputType, inputIndex):
	playersType[index] = inputType
	playersIndex[index] = inputIndex
	isPlaying[index] = true
	playersNumber = 0
	for x in isPlaying:
		if x: playersNumber += 1

func get_axis(player):
	if (playersType[player - 1] == -1): return null
	if (playersType[player - 1] == 0):
		return Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if (playersType[player - 1] == 1):
		var axis = Vector2(Input.get_joy_axis(playersIndex[player - 1], 0), Input.get_joy_axis(playersIndex[player - 1], 1))
		if abs(axis.x) < gamepadDeadzone:
			axis.x = 0
		if abs(axis.y) < gamepadDeadzone:
			axis.y = 0
		print(axis)
		return axis.normalized()
	if (playersType[player - 1] == 2):
		return Vector2(float(Input.is_action_pressed("touch_right")) - float(Input.is_action_pressed("touch_left")), float(Input.is_action_pressed("touch_down")) - float(Input.is_action_pressed("touch_up"))).clamped(1)