extends TileMapLayer

func toggleSecretWall():
	visible = !visible
	collision_enabled = !collision_enabled
