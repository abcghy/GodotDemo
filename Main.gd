extends Node2D

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	print("结束")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$Music.play()


func _on_MobTimer_timeout():
	var mob = Mob.instance()
	add_child(mob)
	
	$MobPath/MobSpawnLocation.set_offset(randi())
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	$HUD.connect("start_game", mob, "_on_start_game")


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	print("分数：", score)


func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()
	print("开始")
