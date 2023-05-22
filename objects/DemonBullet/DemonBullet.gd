extends Node2D

var player = Vector2(0, 0)
var move = Vector2(0, 0)
var vel


func _ready():
	vel = rand_range(Level.bulletsVelRange.x, Level.bulletsVelRange.y)
	look_at(player)
	
	var x1 = abs(player.x - position.x)
	var y1 = abs(player.y - position.y)
	
	var x2 = vel * (x1 / sqrt(pow(x1, 2) + pow(y1, 2)))
	var y2 = sqrt( pow(vel, 2) - pow(x2, 2))
	
	
	if (position.x > player.x):
		x2 *= -1
	if (position.y > player.y):
		y2 *= -1
		
	move = Vector2(x2, y2)

func _process(delta):
	position += move.normalized() * vel * delta
	if position.x <= -200 or position.y <= -200 or position.x >= get_viewport().size.x + 200 or position.y >= get_viewport().size.y + 200:
		queue_free()

func _on_Bullet_body_entered(body):
	if (body.isPlayer and !body.isDestroyed and !body.isColdown):
		#Level.bulletActivate = false
		if body.thirdSpecial:
			queue_free()
			return
		body.destroyed()
		#Level.restart_level()


func _on_First_body_entered(body):
	if (body.isPlayer and !body.isDestroyed and !body.isColdown):
		if body.thirdSpecial: queue_free()
		else: 
			spawn_miniBullets()
			body.destroyed()


func spawn_miniBullets():
	Music.splitSFX.play()
	for x in range(4):
		var newMiniBullet = Preloader.enemie_miniBullet.instance()
		newMiniBullet.move = Level.miniBulletsDirections[x]
		newMiniBullet.name = "MiniBullet_" + str(x) + "_" + self.name
		newMiniBullet.global_position = self.global_position
		get_parent().add_child(newMiniBullet)
	queue_free()

func spawn_extra_miniBullet():
	var newMiniBullet = Preloader.enemie_miniBullet.instance()
	newMiniBullet.move = get_viewport().size / 2
	newMiniBullet.name = "MiniBullet_4_" + self.name
	newMiniBullet.global_position = self.global_position
	get_parent().add_child(newMiniBullet)

func _on_SplitTimer_timeout():
	spawn_extra_miniBullet()
	spawn_miniBullets()
