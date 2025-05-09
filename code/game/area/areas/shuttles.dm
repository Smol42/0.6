
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NO_ALERTS
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	// area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM
	shipambience = 'sound/ambience/zone/shuttle.ogg'
	forced_ambience = TRUE
	ambientsounds = SHUTTLE
	min_ambience_cooldown = 20 SECONDS
	max_ambience_cooldown = 35 SECONDS

/area/shuttle/Initialize(mapload)
	if(!canSmoothWithAreas)
		canSmoothWithAreas = type
	. = ..()

/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Multi-area shuttles////////////////////////////

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/syndicate
	name = "Syndicate Infiltrator"
	ambientsounds = HIGHSEC
	canSmoothWithAreas = /area/shuttle/syndicate

/area/shuttle/solfed
	name = "Solfed Shuttle"
	ambientsounds = SHUTTLE_MILITARY
	canSmoothWithAreas = /area/shuttle/solfed

/area/shuttle/syndicate/bridge
	name = "Syndicate Infiltrator Control"

/area/shuttle/syndicate/medical
	name = "Syndicate Infiltrator Medbay"

/area/shuttle/syndicate/armory
	name = "Syndicate Infiltrator Armory"

/area/shuttle/syndicate/eva
	name = "Syndicate Infiltrator EVA"

/area/shuttle/syndicate/hallway

/area/shuttle/syndicate/airlock
	name = "Syndicate Infiltrator Airlock"

/area/shuttle/syndicate/airlock
	name = "Syndicate Infiltrator Airlock"

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/inteq
	name = "InteQ Infiltrator"
	ambientsounds = SHUTTLE_MILITARY
	canSmoothWithAreas = /area/shuttle/inteq

/area/shuttle/inteq/bridge
	name = "InteQ Infiltrator Control"

/area/shuttle/inteq/medical
	name = "InteQ Infiltrator Medbay"

/area/shuttle/inteq/armory
	name = "InteQ Infiltrator Armory"

/area/shuttle/inteq/eva
	name = "InteQ Infiltrator EVA"

/area/shuttle/inteq/hallway
	name = "InteQ Hallway"

/area/shuttle/inteq/airlock
	name = "InteQ Infiltrator Airlock"

/area/shuttle/inteq/collosus
	name = "InteQ Collosus Shuttle"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "Pirate Shuttle"
	requires_power = TRUE
	canSmoothWithAreas = /area/shuttle/pirate

/area/shuttle/pirate/vault
	name = "Pirate Shuttle Vault"
	requires_power = FALSE

/area/shuttle/pirate/flying_dutchman
	name = "Flying Dutchman"
	requires_power = FALSE

////////////////////////////Bounty Hunter Shuttles////////////////////////////

/area/shuttle/hunter
	name = "Hunter Shuttle"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "Abandoned Ship"
	requires_power = TRUE
	// area_limited_icon_smoothing = /area/shuttle/abandoned
	canSmoothWithAreas = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "Abandoned Ship Bridge"

/area/shuttle/abandoned/engine
	name = "Abandoned Ship Engine"

/area/shuttle/abandoned/bar
	name = "Abandoned Ship Bar"

/area/shuttle/abandoned/crew
	name = "Abandoned Ship Crew Quarters"

/area/shuttle/abandoned/cargo
	name = "Abandoned Ship Cargo Bay"

/area/shuttle/abandoned/medbay
	name = "Abandoned Ship Medbay"

/area/shuttle/abandoned/pod
	name = "Abandoned Ship Pod"

////////////////////////////Single-area shuttles////////////////////////////

/area/shuttle/transit
	name = "Hyperspace"
	desc = "Weeeeee"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/shuttle/custom
	name = "Custom player shuttle"

/area/shuttle/custom/powered
	name = "Custom Powered player shuttle"
	requires_power = FALSE

/area/shuttle/arrival
	name = "Arrival Shuttle"
	area_flags = UNIQUE_AREA// SSjob refers to this area for latejoiners

/area/shuttle/pod_1
	name = "Escape Pod One"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_2
	name = "Escape Pod Two"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_3
	name = "Escape Pod Three"
	area_flags = BLOBS_ALLOWED

/area/shuttle/pod_4
	name = "Escape Pod Four"
	area_flags = BLOBS_ALLOWED

/area/shuttle/mining
	name = "Mining Shuttle"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS

/area/shuttle/mining/large
	name = "Mining Shuttle"
	requires_power = TRUE

/area/shuttle/labor
	name = "Labor Camp Shuttle"
	area_flags = NONE //Set this so it doesn't inherit NO_ALERTS

/area/shuttle/supply
	name = "Supply Shuttle"
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "Emergency Shuttle"
	area_flags = BLOBS_ALLOWED | CULT_PERMITTED | NO_ALERTS
	// area_limited_icon_smoothing = /area/shuttle/escape
	canSmoothWithAreas = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1

/area/shuttle/escape/backup
	name = "Backup Emergency Shuttle"

/area/shuttle/escape/brig
	name = "Escape Shuttle Brig"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "Luxurious Emergency Shuttle"
	// area_flags = NOTELEPORT

/area/shuttle/escape/simulation
	name = "Medieval Reality Simulation Dome"
	icon_state = "shuttlectf"
	area_flags = NOTELEPORT
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/shuttle/escape/arena
	name = "The Arena"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "\proper a meteor with engines strapped to it"
	luminosity = NONE

/area/shuttle/transport
	name = "Transport Shuttle"

/area/shuttle/assault_pod
	name = "Steel Rain"

/area/shuttle/sbc_starfury
	name = "SBC Starfury"

/area/shuttle/sbc_fighter1
	name = "SBC Fighter 1"

/area/shuttle/sbc_fighter2
	name = "SBC Fighter 2"

/area/shuttle/sbc_corvette
	name = "SBC corvette"

/area/shuttle/syndicate_scout
	name = "Syndicate Scout"

// BLUEMOON EDIT START: Invalid Space Turfs
/area/shuttle/ruin
	name = "Ruined Shuttle"

/// Special shuttles made for the Caravan Ambush ruin.
/area/shuttle/ruin/caravan
	requires_power = TRUE
	name = "Ruined Caravan Shuttle"
// BLUEMOON EDIT END: Invalid Space Turfs

/area/shuttle/ruin/caravan/syndicate1 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Syndicate Fighter"

/area/shuttle/ruin/caravan/syndicate2 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Syndicate Fighter"

/area/shuttle/ruin/caravan/syndicate3 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Syndicate Drop Ship"

/area/shuttle/ruin/caravan/pirate // BLUEMOON EDIT: Invalid Space Turfs
	name = "Pirate Cutter"

/area/shuttle/ruin/caravan/freighter1 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Small Freighter"

/area/shuttle/ruin/caravan/freighter2 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Tiny Freighter"

/area/shuttle/ruin/caravan/freighter3 // BLUEMOON EDIT: Invalid Space Turfs
	name = "Tiny Freighter"

/area/shuttle/snowtaxi
	name = "Snow Taxi"

/area/shuttle/tarkoff_driver
	name = "Tarkoff Driver"

/area/shuttle/lf_haron
	name = "Haron"
