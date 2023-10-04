class_name Note extends Node2D

var distance:float = 0 # in ms
var adjusted_distance:float = 0
var time:float = 0
var ID:int = 0 # should match up with strum ID
@onready var curStrum:Strum = get_node("../Strums/Strum"+str(ID))
var notes:Array[Note] = []
var spr:Sprite2D = Sprite2D.new()
@onready var Conductor = get_node("../Conductor")
@onready var rm:RatingManager = get_node("../RatingManager")
static var textures:Array[Texture2D] = [
	preload("res://assets/images/note0.png"),
	preload("res://assets/images/note1.png"),
	preload("res://assets/images/note2.png"),
	preload("res://assets/images/note3.png")
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spr.texture = textures[ID]
	var size = spr.texture.get_size()
	spr.scale = Vector2(110 / size.x, 110 / size.y)
	add_child(spr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	distance = time - Conductor.time # spawn time relative to sound pitch
	adjusted_distance = distance / Conductor.playback_rate # raw ms value, use for judgements
	position.x = $"../Strums".position.x + curStrum.position.x
	position.y = curStrum.position.y - distance * 1.4
	if (distance < -165):
		curStrum.notes.erase(self)
		miss()
	elif (Strum.botplay and distance <= 0):
		curStrum.notes.erase(self)
		hit()
		
func hit() -> void:
	rm.hit(adjusted_distance)
	destroy()

func miss() -> void:
	rm.miss()
	destroy()
	
func destroy() -> void:
	queue_free()
