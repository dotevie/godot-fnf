class_name SoundTray extends Node2D


var _timer:float
@export var silent:bool = false
@onready var label = $Label
@onready var up_snd = $up_snd
@onready var down_snd = $down_snd
var bars:Array[ColorRect] = []
var vol_int:int = int(SoundTray.get_vol(true))
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		bars.append(get_node("Bars/Bar" + str(i)))
	
static func get_vol(first:bool = false) -> float:
	if (first):
		var file := FileAccess.open("user://vol.txt", FileAccess.WRITE_READ)
		var s := file.get_as_text()
		file.close()
		if (s == ""): 
			SoundTray.set_vol(5)
			return 5
		else: 
			set_vol(float(s))
			return float(s)
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 10
	
static func save_vol(vol:int):
	var file := FileAccess.open("user://vol.txt", FileAccess.WRITE)
	file.store_string(str(vol))
	file.close()
	

static func set_vol(vol:float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol / 10))
	SoundTray.save_vol(int(vol))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (_timer > 0):
		_timer -= delta
	elif (position.y > -60):
		position.y -= delta * 1440
		
func show_vol(up:bool):
	if (not silent):
		if (up):
			up_snd.play()
		else:
			down_snd.play()
		
	
	_timer = 1
	position.y = 0
	
	var vol := SoundTray.get_vol()
	var svol := str(floor(vol * 10))
	if (svol.ends_with("9")):
		svol[1] = "0"
		svol[0] = str(int(svol[0]) + 1)
	label.text = "Volume: " + svol + "%"
	
	for i in range(len(bars)):
		if (i < int(svol[0]) or vol >= 10):
			bars[i].modulate.a = 1
		else:
			bars[i].modulate.a = 0.5
			
func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if (Input.is_key_pressed(KEY_EQUAL) and just_pressed):
		vol_int += 1
		if (vol_int > 10): vol_int = 10
		SoundTray.set_vol(vol_int)
		show_vol(true)
	elif (Input.is_key_pressed(KEY_MINUS) and just_pressed):
		vol_int -= 1
		if (vol_int < 0): vol_int = 0
		SoundTray.set_vol(vol_int)
		show_vol(false)
