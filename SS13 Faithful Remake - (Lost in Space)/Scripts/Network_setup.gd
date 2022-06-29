extends Control

var player = load("res://Scenes/Player.tscn")

onready var mutiplayer_config_ui = $Mutiplayer_configure
onready var Background_ui = $CanvasLayer2/TextureRect
onready var server_ip_address = $Mutiplayer_configure/Server_ip_address

onready var device_ip_address = $CanvasLayer/device_ip_address

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")

	device_ip_address.text = Network.ip_address

func _player_connected(id) -> void:
	print("Player " + str(id) + "has connected")
	
	instance_player(id)

func _player_disconnected(id) -> void:
	print("Player " + str(id) + "has disconnected")

	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_Create_server_pressed():
	mutiplayer_config_ui.hide()
	Background_ui.hide()
	Network.create_server()
	
	instance_player(get_tree().get_network_unique_id())

func _on_Join_server_pressed():
	if server_ip_address.text !=  "":
		mutiplayer_config_ui.hide()
		Background_ui.hide()
		Network.ip_address = server_ip_address.text
		Network.join_server()

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	var player_instance  = Global.instance_node_at_location(player, Players, Vector2(rand_range(0, 1920), rand_range(0, 1080)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
