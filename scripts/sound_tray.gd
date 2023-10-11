class_name SoundTray extends Node2D


var _timer:float
@export var silent:bool = false
@onready var label = $Label
@onready var up_snd = $up_snd
@onready var down_snd = $down_snd
var bars:Array[ColorRect] = []
var vol_int:int = get_vol()
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		bars.append(get_node("Bars/Bar" + str(i)))
	
static func get_vol() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 10

static func set_vol(vol:float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol / 10))



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
	
	var vol := get_vol()
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
	var cur_vol:float = floor(get_vol() * 10) / 10
	if (Input.is_key_pressed(KEY_EQUAL) and just_pressed):
		vol_int += 1
		if (vol_int > 10): vol_int = 10
		set_vol(vol_int)
		show_vol(true)
	elif (Input.is_key_pressed(KEY_MINUS) and just_pressed):
		vol_int -= 1
		if (vol_int < 0): vol_int = 0
		set_vol(vol_int)
		show_vol(false)
