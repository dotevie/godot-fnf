class_name RatingManager extends Node2D

@onready var ratingText:Label = $RatingText
@onready var comboText:Label = $ComboText
@onready var msText:Label = $MsText

var tween = create_tween()
var tween2 = create_tween()
var tween3 = create_tween()
var tween4 = create_tween()
var tween5 = create_tween()
var tween6 = create_tween()


var ratings:Dictionary = {
	"awful":  [50, 165, 0],
	"bad":  [100, 135, 0.34],
	"good":  [200, 90, 0.67],
	"sick":  [350, 45, 1],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ratingText.position.x = -30 * ratingText.scale.x
	ratingText.position.y = -30 * ratingText.scale.y
	comboText.position.x = -30 * comboText.scale.x
	msText.position.x = -30 *msText.scale.x
	msText.position.y = 60 *msText.scale.y
	
var combo:int = 0
var score:int = 0
var total_notes:int = 0
var adjusted_notes:float = 0
var misses:int = 0

func hit(window:int):
	var rate:Array = []
	var name:String = ""
	for r in ratings.keys():
		if (abs(window) < ratings.get(r)[1]):
			rate = ratings.get(r)
			name = r
	combo += 1
	total_notes += 1
	adjusted_notes += rate[2]
	score += rate[0]
	ratingText.text = name
	comboText.text = str(combo)
	msText.text = str(-window) + " ms"
	if(tween): tween.kill()
	if(tween2): tween2.kill()
	if(tween3): tween3.kill()
	tween = create_tween()
	tween2 = create_tween()
	tween3 = create_tween()
	if(tween4): tween4.kill()
	if(tween5): tween5.kill()
	if(tween6): tween6.kill()
	tween4 = create_tween()
	tween5 = create_tween()
	tween6 = create_tween()
	ratingText.modulate = Color.WHITE
	comboText.modulate = Color.WHITE
	msText.modulate = Color.WHITE
	ratingText.scale = Vector2(1.1, 1.1)
	comboText.scale = Vector2(1.1, 1.1)
	msText.scale = Vector2(0.55, 0.55)
	tween.tween_property(ratingText, "modulate", Color.TRANSPARENT, .5)
	tween2.tween_property(comboText, "modulate", Color.TRANSPARENT, .5)
	tween3.tween_property(msText, "modulate", Color.TRANSPARENT, .5)
	tween4.tween_property(ratingText, "scale", Vector2.ONE, .1)
	tween5.tween_property(comboText, "scale", Vector2.ONE, .1)
	tween6.tween_property(msText, "scale", Vector2(0.5, 0.5), .1)

func miss():
	combo = 0
	ratingText.text = "miss"
	comboText.text = "0"
	misses += 1
	total_notes += 1
	if(tween): tween.kill()
	if(tween2): tween2.kill()
	if(tween3): tween3.kill()
	tween = create_tween()
	tween2 = create_tween()
	tween3 = create_tween()
	if(tween4): tween4.kill()
	if(tween5): tween5.kill()
	if(tween6): tween6.kill()
	tween4 = create_tween()
	tween5 = create_tween()
	tween6 = create_tween()
	var col:Color = Color.RED
	col.a = 0
	ratingText.modulate = Color.RED
	comboText.modulate = Color.RED
	msText.modulate = Color.TRANSPARENT
	ratingText.scale = Vector2(0.9, 0.9)
	comboText.scale = Vector2(0.9, 0.9)
	tween.tween_property(ratingText, "modulate", col, .5)
	tween2.tween_property(comboText, "modulate", col, .5)
	tween4.tween_property(ratingText, "scale", Vector2.ONE, .1)
	tween5.tween_property(comboText, "scale", Vector2.ONE, .1)

