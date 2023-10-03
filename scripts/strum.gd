class_name Strum extends Node2D

@export var key:Key = Key.KEY_D
var notes:Array[Note] = []
@onready var spr:Sprite2D = $Sprite2D
@onready var ChartLoader = $"../../ChartLoader"
static var botplay:bool = true
static var textures:Array[Texture2D] = [
	preload("res://assets/images/strum0.png"),
	preload("res://assets/images/strum1.png"),
	preload("res://assets/images/strum2.png"),
	preload("res://assets/images/strum3.png")
]
static var pressedVec:Vector2 = Vector2(0.9, 0.9)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spr.texture = textures[ChartLoader.strums.find(self)]
	var size = spr.texture.get_size()
	spr.scale = Vector2(110 / size.x, 110 / size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if (Input.is_key_pressed(key) and not botplay): scale = pressedVec
	else: scale = Vector2.ONE


func _input(event) -> void:
	if (len(notes) < 1 or botplay): return
	var just_pressed = event.is_pressed() and not event.is_echo()
	if (Input.is_key_pressed(key) and just_pressed):
		if (notes[0].distance >= -165 and notes[0].distance <= 165):
			var nt = notes[0]
			if (nt != null): nt.hit()
			notes.erase(nt)
			if (nt != null): nt.destroy()
