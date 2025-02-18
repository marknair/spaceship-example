extends Area2D

var gem_count = 0
var health = 10
var normal_speed = 600.0
var max_speed = normal_speed
var boost_speed = 1500.0
var velocity = Vector2.ZERO
var steering_factor = 10

func _ready():
	area_entered.connect(_on_area_entered)
	set_health(50)

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()
		
	var desired_velocity = max_speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	
	if velocity.length() > 0.0:
		#rotation = velocity.angle() + PI/2
		$Sprite2D.rotation = velocity.angle() + PI/2
		
	var viewport_size = get_viewport_rect().size
	
	position.x = wrapf(position.x, 0, viewport_size.x)
	position.y = wrapf(position.y, 0, viewport_size.y)

func _on_timer_timeout() -> void:
	max_speed = normal_speed
	
func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health

func _on_area_entered(area_that_entered: Area2D) -> void:
	if area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + 1)
	elif area_that_entered.is_in_group("healing_item"):
		set_health(health + 25)
	
func set_gem_count(new_gem_count: int) -> void:
	gem_count = new_gem_count
	get_node("UI/GemCount").text = "x" + str(gem_count)
