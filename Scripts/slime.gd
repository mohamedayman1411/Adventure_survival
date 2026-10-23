extends CharacterBody2D

const SPEED: int = 100
const KNOCKBACK_FORCE: int = 100

var is_alive:bool = true
var health: int = 100
var target = null

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var take_Damage_Sound: AudioStreamPlayer2D = $TakeDamage
@onready var health_bar: Node2D = $HealthBar


func _physics_process(delta: float) -> void:
	if is_alive and target:
		_attack(delta)



func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta
	animated_sprite_2d.play("attack")

func take_damage(damage : int, attacker_position:Vector2) -> void:
	health -= damage
	health_bar.update_health(health)
	if health <= 0:
		_die()
	else:
		take_Damage_Sound.play()
		#knockBack
		var knockBack_direction = (position - attacker_position ).normalized()
		var target_position = position + knockBack_direction * KNOCKBACK_FORCE
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", target_position,0.5)
		tween.set_trans(Tween.TRANS_CUBIC)


func  _die() -> void:
	is_alive = false
	animated_sprite_2d.play("die")
	
	take_Damage_Sound.pitch_scale = 0.5
	take_Damage_Sound.play()
	
	#disabled collision
	$CollisionShape2D.set_deferred("disabled", true)
	$Sight/CollisionShape2D.set_deferred("disabled", true)

func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body


func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "Player" and is_alive:
		target = body
		animated_sprite_2d.play("idle")
		
		
		
