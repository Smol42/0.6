GLOBAL_LIST_EMPTY(station_turfs)

/// Any floor or wall. What makes up the station and the rest of the map.
/turf
	icon = 'icons/turf/floors.dmi'
	flags_1 = CAN_BE_DIRTY_1
	vis_flags = VIS_INHERIT_ID|VIS_INHERIT_PLANE // Important for interaction with and visualization of openspace.
	luminosity = 1

	var/intact = 1

	// baseturfs can be either a list or a single turf type.
	// In class definition like here it should always be a single type.
	// A list will be created in initialization that figures out the baseturf's baseturf etc.
	// In the case of a list it is sorted from bottom layer to top.
	// This shouldn't be modified directly, use the helper procs.
	var/list/baseturfs = /turf/baseturf_bottom

	var/initial_temperature = T20C
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

	var/blocks_air = FALSE

	var/list/image/blueprint_data //for the station blueprints, images of objects eg: pipes

	var/explosion_level = 0	//for preventing explosion dodging
	var/explosion_id = 0

	var/requires_activation	//add to air processing after initialize?
	var/changing_turf = FALSE

	var/bullet_bounce_sound = 'sound/weapons/bulletremove.ogg' //sound played when a shell casing is ejected ontop of the turf.
	var/bullet_sizzle = FALSE //used by ammo_casing/bounce_away() to determine if the shell casing should make a sizzle sound when it's ejected over the turf
							//IE if the turf is supposed to be water, set TRUE.

	var/tiled_dirt = FALSE // use smooth tiled dirt decal

	///the holodeck can load onto this turf if TRUE
	var/holodeck_compatible = FALSE

	/// If there's a tile over a basic floor that can be ripped out
	var/overfloor_placed = FALSE

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list("x", "y", "z")
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/**
 * Turf Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize]
 */
/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.Cut()

	if(color) // is this being used? This is here because parent isn't being called
		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

	assemble_baseturfs()

	levelupdate()
	if(smooth)
		queue_smooth(src)

	visibilityChanged()

	for(var/atom/movable/AM in src)
		Entered(AM)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if(requires_activation)
		CALCULATE_ADJACENT_TURFS(src)

	if (light_power && light_range)
		update_light()

	var/turf/T = SSmapping.get_turf_above(src)
	if(T)
		T.multiz_turf_new(src, DOWN)
	T = SSmapping.get_turf_below(src)
	if(T)
		T.multiz_turf_new(src, UP)


	if (opacity)
		has_opaque_atom = TRUE

	// apply materials properly from the default custom_materials value
	set_custom_materials(custom_materials)

	ComponentInitialize()
	if(isopenturf(src))
		var/turf/open/O = src
		__auxtools_update_turf_temp_info(isspaceturf(get_z_base_turf()) && !O.planetary_atmos)
	else
		update_air_ref(-1)
		__auxtools_update_turf_temp_info(isspaceturf(get_z_base_turf()))

	return INITIALIZE_HINT_NORMAL

/turf/proc/__auxtools_update_turf_temp_info()

/turf/return_temperature()

/turf/proc/set_temperature()

/turf/proc/Initalize_Atmos(times_fired)
	CALCULATE_ADJACENT_TURFS(src)

/turf/Destroy(force)
	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		stack_trace("Incorrect turf deletion")
	changing_turf = FALSE
	var/turf/T = SSmapping.get_turf_above(src)
	if(T)
		T.multiz_turf_del(src, DOWN)
	T = SSmapping.get_turf_below(src)
	if(T)
		T.multiz_turf_del(src, UP)
	if(force)
		..()
		//this will completely wipe turf state
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		return
	visibilityChanged()
	QDEL_LIST(blueprint_data)
	flags_1 &= ~INITIALIZED_1
	requires_activation = FALSE
	..()

	vis_contents.Cut()

/turf/on_attack_hand(mob/user)
	user.Move_Pulled(src)

/turf/proc/multiz_turf_del(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, T, dir)

/turf/proc/multiz_turf_new(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, T, dir)

/**
 * Check whether the specified turf is blocked by something dense inside it with respect to a specific atom.
 *
 * Returns truthy value TURF_BLOCKED_TURF_DENSE if the turf is blocked because the turf itself is dense.
 * Returns truthy value TURF_BLOCKED_CONTENT_DENSE if one of the turf's contents is dense and would block
 * a source atom's movement.
 * Returns falsey value TURF_NOT_BLOCKED if the turf is not blocked.
 *
 * Arguments:
 * * exclude_mobs - If TRUE, ignores dense mobs on the turf.
 * * source_atom - If this is not null, will check whether any contents on the turf can block this atom specifically. Also ignores itself on the turf.
 * * ignore_atoms - Check will ignore any atoms in this list. Useful to prevent an atom from blocking itself on the turf.
 */
/turf/proc/is_blocked_turf(exclude_mobs = FALSE, source_atom = null, list/ignore_atoms)
	if(density)
		return TRUE

	for(var/atom/movable/movable_content as anything in contents)
		// We don't want to block ourselves or consider any ignored atoms.
		if((movable_content == source_atom) || (movable_content in ignore_atoms))
			continue
		// If the thing is dense AND we're including mobs or the thing isn't a mob AND if there's a source atom and
		// it cannot pass through the thing on the turf,  we consider the turf blocked.
		if(movable_content.density && (!exclude_mobs || !ismob(movable_content)))
			if(source_atom && movable_content.CanPass(source_atom, get_dir(src, source_atom)))
				continue
			return TRUE
	return FALSE

/**
 * Checks whether the specified turf is blocked by something dense inside it, but ignores anything with the climbable trait
 *
 * Works similar to is_blocked_turf(), but ignores climbables and has less options. Primarily added for jaunting checks
 */
/turf/proc/is_blocked_turf_ignore_climbable()
	if(density)
		return TRUE

	for(var/atom/movable/atom_content as anything in contents)
		if(atom_content.density && !(atom_content.flags_1 & ON_BORDER_1) && !HAS_TRAIT(atom_content, TRAIT_CLIMBABLE))
			return TRUE
	return FALSE

//zPassIn doesn't necessarily pass an atom!
//direction is direction of travel of air
/turf/proc/zPassIn(atom/movable/A, direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zPassOut(atom/movable/A, direction, turf/destination)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirIn(direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zAirOut(direction, turf/source)
	return FALSE

/turf/proc/zImpact(atom/movable/A, levels = 1, turf/prev_turf)
	var/flags = NONE
	var/mov_name = A.name
	for(var/i in contents)
		var/atom/thing = i
		flags |= thing.intercept_zImpact(A, levels)
		if(flags & FALL_STOP_INTERCEPTING)
			break
	if(prev_turf && !(flags & FALL_NO_MESSAGE))
		prev_turf.visible_message("<span class='danger'>[mov_name] falls through [prev_turf]!</span>")
	if(flags & FALL_INTERCEPTED)
		return
	if(zFall(A, levels + 1))
		return FALSE
	A.visible_message("<span class='danger'>[A] crashes into [src]!</span>")
	A.onZImpact(src, levels)
	return TRUE

/turf/proc/can_zFall(atom/movable/A, levels = 1, turf/target)
	SHOULD_BE_PURE(TRUE)
	return zPassOut(A, DOWN, target) && target.zPassIn(A, DOWN, src)

/turf/proc/zFall(atom/movable/A, levels = 1, force = FALSE)
	var/turf/target = get_step_multiz(src, DOWN)
	if(!target || (!isobj(A) && !ismob(A)))
		return FALSE
	if(!force && (!can_zFall(A, levels, target) || !A.can_zFall(src, levels, target, DOWN)))
		return FALSE
	if(isliving(A))
		var/mob/living/falling_mob = A
		var/atom/movable/pulling = falling_mob.pulling
		falling_mob.zfalling = TRUE
		falling_mob.forceMove(target)
		falling_mob.zfalling = FALSE
		target.zImpact(falling_mob, levels, src)
		if(pulling)
			pulling.zfalling = TRUE
			pulling.forceMove(target)
			pulling.zfalling = FALSE
			target.zImpact(pulling, levels, src)
			INVOKE_ASYNC(falling_mob, TYPE_PROC_REF(/atom/movable, start_pulling), pulling)
	else
		A.zfalling = TRUE
		A.forceMove(target)
		A.zfalling = FALSE
		target.zImpact(A, levels, src)
	return TRUE

/turf/proc/handleRCL(obj/item/rcl/C, mob/user)
	if(C.loaded)
		for(var/obj/structure/cable/LC in src)
			if(!LC.d1 || !LC.d2)
				LC.handlecable(C, user)
				return
		C.loaded.place_turf(src, user)
		if(C.wiring_gui_menu)
			C.wiringGuiUpdate(user)
		C.is_empty(user)

/turf/attackby(obj/item/C, mob/user, params)
	if(..())
		return TRUE
	if(can_lay_cable() && istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		for(var/obj/structure/cable/LC in src)
			if(!LC.d1 || !LC.d2)
				LC.attackby(C,user)
				return
		coil.place_turf(src, user)
		return TRUE

	else if(istype(C, /obj/item/rcl))
		handleRCL(C, user)

	return FALSE

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
// Test if a movable can enter this turf. Send no_side_effects = TRUE to prevent bumping.
/turf/Enter(atom/movable/mover, atom/oldloc, no_side_effects = FALSE) // BLUEMOON EDIT
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/canPassSelf = CanPass(mover, src)
	if(canPassSelf || (mover.movement_type & PHASING))
		for(var/i in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(i == mover || i == mover.loc) // Multi tile objects and moving out of other objects
				continue
			var/atom/movable/thing = i
			if(!thing.Cross(mover))
				// MODULAR_JUICY-ADD
				if(no_side_effects)
					return FALSE
				// MODULAR_JUICY-ADD
				if(QDELETED(mover))		//Mover deleted from Cross/CanPass, do not proceed.
					return FALSE
				if((mover.movement_type & PHASING))
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags_1 & ON_BORDER_1) && !(firstbump.flags_1 & ON_BORDER_1)))
						firstbump = thing
	if(QDELETED(mover))					//Mover deleted from Cross/CanPass/Bump, do not proceed.
		return FALSE
	if(!canPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return (mover.movement_type & PHASING)
	return TRUE

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!. || QDELETED(mover))
		return FALSE
	for(var/i in contents)
		if(i == mover)
			continue
		var/atom/movable/thing = i
		if(!thing.Uncross(mover, newloc))
			if(thing.flags_1 & ON_BORDER_1)
				mover.Bump(thing)
			if(!(mover.movement_type & PHASING))
				return FALSE
		if(QDELETED(mover))
			return FALSE		//We were deleted.

/turf/Entered(atom/movable/AM)
	..()
	if(explosion_level && AM.ex_check(explosion_id))
		AM.ex_act(explosion_level)

	// If an opaque movable atom moves around we need to potentially update visibility.
	if (AM.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()


/turf/open/Entered(atom/movable/AM)
	..()
	//melting
	if(isobj(AM) && air && air.return_temperature() > T0C)
		var/obj/O = AM
		if(O.obj_flags & FROZEN)
			O.make_unfrozen()
	if(!AM.zfalling)
		zFall(AM)

/turf/proc/is_plasteel_floor()
	return FALSE

// A proc in case it needs to be recreated or badmins want to change the baseturfs
/turf/proc/assemble_baseturfs(turf/fake_baseturf_type)
	var/static/list/created_baseturf_lists = list()
	var/turf/current_target
	if(fake_baseturf_type)
		if(length(fake_baseturf_type)) // We were given a list, just apply it and move on
			baseturfs = fake_baseturf_type
			return
		current_target = fake_baseturf_type
	else
		if(length(baseturfs))
			return // No replacement baseturf has been given and the current baseturfs value is already a list/assembled
		if(!baseturfs)
			current_target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [current_target].")
		else
			current_target = baseturfs

	// If we've made the output before we don't need to regenerate it
	if(created_baseturf_lists[current_target])
		var/list/premade_baseturfs = created_baseturf_lists[current_target]
		if(length(premade_baseturfs))
			baseturfs = premade_baseturfs.Copy()
		else
			baseturfs = premade_baseturfs
		return baseturfs

	var/turf/next_target = initial(current_target.baseturfs)
	//Most things only have 1 baseturf so this loop won't run in most cases
	if(current_target == next_target)
		baseturfs = current_target
		created_baseturf_lists[current_target] = current_target
		return current_target
	var/list/new_baseturfs = list(current_target)
	for(var/i=0;current_target != next_target;i++)
		if(i > 100)
			// A baseturfs list over 100 members long is silly
			// Because of how this is all structured it will only runtime/message once per type
			stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			break
		new_baseturfs.Insert(1, next_target)
		current_target = next_target
		next_target = initial(current_target.baseturfs)

	baseturfs = new_baseturfs
	created_baseturf_lists[new_baseturfs[new_baseturfs.len]] = new_baseturfs.Copy()
	return new_baseturfs

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.flags_1 & INITIALIZED_1)
			// SEND_SIGNAL(O, COMSIG_OBJ_HIDE, intact)
			O.hide(intact)

// override for space turfs, since they should never hide anything
/turf/open/space/levelupdate()
	return

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L && (L.flags_1 & INITIALIZED_1))
		qdel(L)

/turf/proc/phase_damage_creatures(damage,mob/U = null)//>Ninja Code. Hurts and knocks out creatures on this turf //NINJACODE
	for(var/mob/living/M in src)
		if(M==U)
			continue//Will not harm U. Since null != M, can be excluded to kill everyone.
		M.adjustBruteLoss(damage)
		M.Unconscious(damage * 4)
	for(var/obj/vehicle/sealed/mecha/M in src)
		M.take_damage(damage*2, BRUTE, MELEE, 1)

/turf/proc/Bless()
	new /obj/effect/blessing(src)

/turf/storage_contents_dump_act(datum/component/storage/src_object, mob/user)
	. = ..()
	if(.)
		return
	if(length(src_object.contents()))
		to_chat(usr, "<span class='notice'>You start dumping out the contents...</span>")
		if(!do_after(usr,20,target=src_object.parent))
			return FALSE

	var/list/things = src_object.contents()
	var/datum/progressbar/progress = new(user, things.len, src)
	while (do_after(usr, 1 SECONDS, src, NONE, FALSE, CALLBACK(src_object, TYPE_PROC_REF(/datum/component/storage, mass_remove_from_storage), src, things, progress, TRUE, user)))
		stoplag(1)
	progress.end_progress()

	return TRUE

//////////////////////////////
//Distance procs
//////////////////////////////

//Distance associates with all directions movement
/turf/proc/Distance(var/turf/T)
	return get_dist(src,T)

//  This Distance proc assumes that only cardinal movement is
//  possible. It results in more efficient (CPU-wise) pathing
//  for bots and anything else that only moves in cardinal dirs.
/turf/proc/Distance_cardinal(turf/T)
	if(!src || !T)
		return FALSE
	return abs(x - T.x) + abs(y - T.y)

////////////////////////////////////////////////////

/turf/singularity_act()
	if(intact)
		for(var/obj/O in contents) //this is for deleting things like wires contained in the turf
			if(O.level != 1)
				continue
			if(O.invisibility == INVISIBILITY_MAXIMUM)
				O.singularity_act()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return(2)

/turf/proc/can_have_cabling()
	return TRUE

/turf/proc/can_lay_cable()
	return can_have_cabling() & !intact

/turf/proc/visibilityChanged()
	GLOB.cameranet.updateVisibility(src)
	// The cameranet usually handles this for us, but if we've just been
	// recreated we should make sure we have the cameranet vis_contents.
	var/datum/camerachunk/C = GLOB.cameranet.chunkGenerated(x, y, z)
	if(C)
		if(C.obscuredTurfs[src])
			vis_contents += GLOB.cameranet.vis_contents_objects
		else
			vis_contents -= GLOB.cameranet.vis_contents_objects

/turf/proc/burn_tile()

/turf/proc/is_shielded()

/turf/contents_explosion(severity, target, origin)
	var/affecting_level
	if(severity == 1)
		affecting_level = 1
	else if(is_shielded())
		affecting_level = 3
	else if(intact)
		affecting_level = 2
	else
		affecting_level = 1

	for(var/V in contents)
		var/atom/A = V
		if(!QDELETED(A) && A.level >= affecting_level)
			if(ismovable(A))
				var/atom/movable/AM = A
				if(!AM.ex_check(explosion_id))
					continue
			A.ex_act(severity, target, origin)
			CHECK_TICK

/turf/wave_ex_act(power, datum/wave_explosion/explosion, dir)
	. = ..()
	var/affecting_level
	if(is_shielded())
		affecting_level = 3
	else if(intact)
		affecting_level = 2
	else
		affecting_level = 1
	var/atom/A
	for(var/i in contents)
		if(. <= 0)
			return FALSE
		A = i
		if(!QDELETED(A) && A.level >= affecting_level)
			.  = A.wave_explode(., explosion, dir)
	maptext = MAPTEXT("[.]")

/turf/narsie_act(force, ignore_mobs, probability = 20)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.narsie_act()

/turf/ratvar_act(force, ignore_mobs, probability = 40)
	. = (prob(probability) || force)
	for(var/I in src)
		var/atom/A = I
		if(ignore_mobs && ismob(A))
			continue
		if(ismob(A) || .)
			A.ratvar_act()

//called on /datum/species/proc/altdisarm()
/turf/shove_act(mob/living/target, mob/living/user, pre_act = FALSE)
	var/list/possibilities
	for(var/obj/O in contents)
		if((O.obj_flags & SHOVABLE_ONTO))
			LAZYADD(possibilities, O)
		else if(!O.CanPass(target, src))
			return FALSE
	if(possibilities)
		var/obj/O = pick(possibilities)
		return O.shove_act(target, user)
	return FALSE

/turf/proc/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = icon
	underlay_appearance.icon_state = icon_state
	underlay_appearance.dir = adjacency_dir
	return TRUE

/turf/proc/add_blueprints(atom/movable/AM)
	var/image/I = new
	I.appearance = AM.appearance
	I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM
	I.loc = src
	I.setDir(AM.dir)
	I.alpha = 128
	LAZYADD(blueprint_data, I)

/turf/proc/add_blueprints_preround(atom/movable/AM)
	if(!SSticker.HasRoundStarted())
		add_blueprints(AM)

/turf/proc/is_transition_turf()
	return

/turf/acid_act(acidpwr, acid_volume)
	. = 1
	var/acid_type = /obj/effect/acid
	if(acidpwr >= 200) //alien acid power
		acid_type = /obj/effect/acid/alien
	var/has_acid_effect = FALSE
	for(var/obj/O in src)
		if(intact && O.level == 1) //hidden under the floor
			continue
		if(istype(O, acid_type))
			var/obj/effect/acid/A = O
			A.acid_level = min(A.level + acid_volume * acidpwr, 12000)//capping acid level to limit power of the acid
			has_acid_effect = 1
			continue
		O.acid_act(acidpwr, acid_volume)
	if(!has_acid_effect)
		new acid_type(src, acidpwr, acid_volume)

/turf/proc/acid_melt()
	return

/turf/handle_fall(mob/faller, forced)
	faller.lying = pick(90, 270)
	if(!forced)
		return
	if(has_gravity(src))
		playsound(src, "bodyfall", 50, TRUE)
	faller.drop_all_held_items()

/turf/proc/photograph(limit=20)
	var/image/I = new()
	I.add_overlay(src)
	for(var/V in contents)
		var/atom/A = V
		if(A.invisibility)
			continue
		I.add_overlay(A)
		if(limit)
			limit--
		else
			return I
	return I

/turf/AllowDrop()
	return TRUE

/turf/proc/add_vomit_floor(mob/living/M, toxvomit = NONE, purge_ratio = 0.1)

	var/obj/effect/decal/cleanable/vomit/V = new /obj/effect/decal/cleanable/vomit(src, M.get_static_viruses())
	//if the vomit combined, apply toxicity and reagents to the old vomit
	if (QDELETED(V))
		V = locate() in src
	if(!V) //the decal was spawned on a wall or groundless turf and promptly qdeleted.
		return
	// Apply the proper icon set based on vomit type
	if(toxvomit == VOMIT_PURPLE)
		V.icon_state = "vomitpurp_[pick(1,4)]"
	else if (toxvomit == VOMIT_TOXIC)
		V.icon_state = "vomittox_[pick(1,4)]"
	else if (toxvomit == VOMIT_NANITE)
		V.name = "metallic slurry"
		V.desc = "A puddle of metallic slurry that looks vaguely like very fine sand. It almost seems like it's moving..."
		V.icon_state = "vomitnanite_[pick(1,4)]"
	if (purge_ratio && iscarbon(M))
		clear_reagents_to_vomit_pool(M, V, purge_ratio)

/proc/clear_reagents_to_vomit_pool(mob/living/carbon/M, obj/effect/decal/cleanable/vomit/V, purge_ratio = 0.1)
	for(var/datum/reagent/consumable/R in M.reagents.reagent_list)                //clears the stomach of anything that might be digested as food
		if(R.nutriment_factor > 0)
			M.reagents.del_reagent(R.type)
	var/chemicals_lost = M.reagents.total_volume * purge_ratio
	M.reagents.trans_to(V, chemicals_lost)

//Whatever happens after high temperature fire dies out or thermite reaction works.
//Should return new turf
/turf/proc/Melt()
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/proc/get_yelling_resistance(power)
	. = 0
	// don't bother checking fulltile, we don't need accuracy
	var/obj/window = locate(/obj/structure/window) in src
	if(!window)
		window = locate(/obj/machinery/door/window) in src
	if(window)
		. += 4		// windows are minimally resistant
	// if there's more than one someone fucked up as that shouldn't happen
	var/obj/machinery/door/D = locate() in src
	if(D?.density)
		. += D.opacity? 29 : 19			// glass doors are slightly more resistant to screaming

/**
 * Returns adjacent turfs to this turf that are reachable, in all cardinal directions
 *
 * Arguments:
 * * caller: The movable, if one exists, being used for mobility checks to see what tiles it can reach
 * * ID: An ID card that decides if we can gain access to doors that would otherwise block a turf
 * * simulated_only: Do we only worry about turfs with simulated atmos, most notably things that aren't space?
*/
/turf/proc/reachableAdjacentTurfs(caller, ID, simulated_only)
	var/static/space_type_cache = typecacheof(/turf/open/space)
	. = list()

	for(var/iter_dir in GLOB.cardinals)
		var/turf/turf_to_check = get_step(src,iter_dir)
		if(!turf_to_check || (simulated_only && space_type_cache[turf_to_check.type]))
			continue
		if(turf_to_check.density || LinkBlockedWithAccess(turf_to_check, caller, ID))
			continue
		. += turf_to_check

/// Called when attempting to set fire to a turf
/turf/proc/IgniteTurf(power, fire_color="red")
	return

/// Returns adjacent turfs in cardinal directions that are reachable via atmos
/turf/proc/reachableAdjacentAtmosTurfs()
	return atmos_adjacent_turfs
