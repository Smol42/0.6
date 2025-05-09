
/*
	Uplink Items:
	Unlike categories, uplink item entries are automatically sorted alphabetically on server init in a global list,
	When adding new entries to the file, please keep them sorted by category.
*/

// Ammunition

/datum/uplink_item/ammo/derringer
	name = "Ammo Box - .45-70 GOVT"
	desc = "Contains 10 additional .45-70 GOVT rounds. Caliber is exceedingly rare, and thus, comes at a premium."
	item = /obj/item/ammo_box/g4570
	cost = 5
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/pistol
	name = "10mm Handgun Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. These rounds \
			are dirt cheap but are half as effective as .357 rounds."
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 1
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistol/box
	name = "Ammo Box - 10mm"
	desc = "An additional box of 10mm ammo. The box has 20 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/c10mm
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolap
	name = "10mm Armour Piercing Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. \
			These rounds are less effective at injuring the target but penetrate protective gear."
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolap/box
	name = "Ammo Box - 10mm Armour Piercing"
	desc = "An additional box of 10mm Armour Piercing ammo. The box has 20 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/c10mm/ap
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolhp
	name = "10mm Hollow Point Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. \
			These rounds are more damaging but ineffective against armour."
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 3
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolhp/box
	name = "Ammo Box - 10mm Hollow Point"
	desc = "An additional box of 10mm Hollow Point ammo. The box has 20 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/c10mm/hp
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolfire
	name = "10mm Incendiary Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. \
			Loaded with incendiary rounds which inflict little damage, but ignite the target."
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolfire/box
	name = "Ammo Box - 10mm Incendiary"
	desc = "An additional box of 10mm Incendiary ammo. The box has 20 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/magazine/m10mm/fire
	illegal_tech = FALSE

/datum/uplink_item/ammo/pistolzzz
	name = "10mm Soporific Magazine"
	desc = "An additional 8-round 10mm magazine; compatible with the Stechkin Pistol. Loaded with soporific rounds that put the target to sleep. \
			NOTE: Soporific is not instant acting due to the constraints of the round's scale. Will usually require three shots to take effect."
	item = /obj/item/ammo_box/magazine/m10mm/soporific
	cost = 2

/datum/uplink_item/ammo/pistolzzz/box
	name = "Ammo Box - 10mm Soporific"
	desc = "An additional box of 10mm Soporific ammo. The box has 20 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/c10mm/soporific
	illegal_tech = FALSE

/datum/uplink_item/ammo/shotgun
	cost = 2
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/shotgun/bag
	name = "12g Ammo Duffel Bag"
	desc = "A duffel bag filled with enough 12g ammo to supply an entire team, at a discounted price."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/shotgun
	cost = 12

/datum/uplink_item/ammo/shotgun/bioterror
	name = "12g Bioterror Dart Drum"
	desc = "An additional 8-round bioterror dart magazine for use with the Bulldog shotgun. \
			Pierces armor and injects are horrid cocktail of death into your target. Be careful about friendly fire."
	cost = 6 //legacy price
	item = /obj/item/ammo_box/magazine/m12g/bioterror

/datum/uplink_item/ammo/shotgun/buck
	name = "12g Buckshot Drum"
	desc = "An additional 8-round buckshot magazine for use with the Bulldog shotgun. Front towards enemy."
	item = /obj/item/ammo_box/magazine/m12g

/datum/uplink_item/ammo/shotgun/dragon
	name = "12g Dragon's Breath Drum"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. \
			'I'm a fire starter, twisted fire starter!'"
	item = /obj/item/ammo_box/magazine/m12g/dragon

/datum/uplink_item/ammo/shotgun/meteor
	name = "12g Meteorslug Shells"
	desc = "An alternative 8-round meteorslug magazine for use in the Bulldog shotgun. \
			Great for blasting airlocks off their frames and knocking down enemies."
	item = /obj/item/ammo_box/magazine/m12g/meteor

/datum/uplink_item/ammo/shotgun/slug
	name = "12g Slug Drum"
	desc = "An additional 8-round slug magazine for use with the Bulldog shotgun. \
			Now 8 times less likely to shoot your pals."
	cost = 3
	item = /obj/item/ammo_box/magazine/m12g/slug

/datum/uplink_item/ammo/shotgun/stun
	name = "12g Stun Slug Drum"
	desc = "An alternative 8-round stun slug magazine for use with the Bulldog shotgun. \
			Saying that they're completely non-lethal would be lying."
	item = /obj/item/ammo_box/magazine/m12g/stun

/datum/uplink_item/ammo/revolver
	name = ".357 Speed Loader"
	desc = "A speed loader that contains seven additional .357 Magnum rounds, and can be further reloaded with individual bullets; usable with the Syndicate revolver. \
			For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	cost = 3
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/revolver/ap
	name = ".357 Armor Piercing Speed Loader"
	desc = "A speed loader that contains seven additional .357 AP Magnum rounds; usable with the Syndicate revolver. \
			Cuts through like a hot knife through butter."
	item = /obj/item/ammo_box/a357/ap

/datum/uplink_item/ammo/a40mm
	name = "40mm Grenade"
	desc = "A 40mm HE grenade for use with the M-90gl's under-barrel grenade launcher. \
			Your teammates will ask you to not shoot these down small hallways."
	item = /obj/item/ammo_casing/a40mm
	cost = 2
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/smg/bag
	name = ".45 Ammo Duffel Bag"
	desc = "A duffel bag filled with enough .45 ammo to supply an entire team, at a discounted price."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/smg
	cost = 20 //instead of 27 TC
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/smg
	name = ".45 SMG Magazine"
	desc = "An additional 24-round .45 magazine suitable for use with the C-20r submachine gun."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 3
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/sniper
	cost = 4
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/sniper/basic
	name = ".50 Magazine"
	desc = "An additional standard 6-round magazine for use with .50 sniper rifles."
	item = /obj/item/ammo_box/magazine/sniper_rounds

/datum/uplink_item/ammo/sniper/penetrator
	name = ".50 Penetrator Magazine"
	desc = "A 5-round magazine of penetrator ammo designed for use with .50 sniper rifles. \
			Can pierce walls and multiple enemies."
	item = /obj/item/ammo_box/magazine/sniper_rounds/penetrator
	cost = 5

/datum/uplink_item/ammo/sniper/soporific
	name = ".50 Soporific Magazine"
	desc = "A 3-round magazine of soporific ammo designed for use with .50 sniper rifles. Put your enemies to sleep today!"
	item = /obj/item/ammo_box/magazine/sniper_rounds/soporific
	cost = 6

/datum/uplink_item/ammo/carbine
	name = "5.56mm Toploader Magazine"
	desc = "An additional 30-round 5.56mm magazine; suitable for use with the M-90gl carbine. \
			These bullets pack less punch than 7.12x82mm rounds, but they still offer more power than .45 ammo."
	item = /obj/item/ammo_box/magazine/m556
	cost = 4
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/machinegun/match
	name = "7.12x82mm (Match) Box Magazine"
	desc = "A 50-round magazine of 7.12x82mm ammunition for use in the L6 SAW; you didn't know there was a demand for match grade \
			precision bullet hose ammo, but these rounds are finely tuned and perfect for ricocheting off walls all fancy-like."
	item = /obj/item/ammo_box/magazine/mm712x82/match
	cost = 10

/datum/uplink_item/ammo/machinegun
	cost = 6
	surplus = 0
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/machinegun/basic
	name = "7.12x82mm Box Magazine"
	desc = "A 50-round magazine of 7.12x82mm ammunition for use with the L6 SAW. \
			By the time you need to use this, you'll already be standing on a pile of corpses"
	item = /obj/item/ammo_box/magazine/mm712x82

/datum/uplink_item/ammo/machinegun/ap
	name = "7.12x82mm (Armor Penetrating) Box Magazine"
	desc = "A 50-round magazine of 7.12x82mm ammunition for use in the L6 SAW; equipped with special properties \
			to puncture even the most durable armor."
	item = /obj/item/ammo_box/magazine/mm712x82/ap
	cost = 9

/datum/uplink_item/ammo/machinegun/hollow
	name = "7.12x82mm (Hollow-Point) Box Magazine"
	desc = "A 50-round magazine of 7.12x82mm ammunition for use in the L6 SAW; equipped with hollow-point tips to help \
			with the unarmored masses of crew."
	item = /obj/item/ammo_box/magazine/mm712x82/hollow

/datum/uplink_item/ammo/machinegun/incen
	name = "7.12x82mm (Incendiary) Box Magazine"
	desc = "A 50-round magazine of 7.12x82mm ammunition for use in the L6 SAW; tipped with a special flammable \
			mixture that'll ignite anyone struck by the bullet. Some men just want to watch the world burn."
	item = /obj/item/ammo_box/magazine/mm712x82/incen

/datum/uplink_item/ammo/rocket
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/rocket/basic
	name = "84mm HE Rocket"
	desc = "A low-yield anti-personnel HE rocket. Gonna take you out in style!"
	item = /obj/item/ammo_casing/caseless/rocket
	cost = 4

/datum/uplink_item/ammo/rocket/hedp
	name = "84mm HEDP Rocket"
	desc = "A high-yield HEDP rocket; extremely effective against armored targets, as well as surrounding personnel. \
			Strike fear into the hearts of your enemies."
	item = /obj/item/ammo_casing/caseless/rocket/hedp
	cost = 6

/datum/uplink_item/ammo/pistolaps
	name = "9mm Handgun Magazine"
	desc = "An additional 15-round 9mm magazine, compatible with the Stechkin APS pistol."
	item = /obj/item/ammo_box/magazine/pistolm9mm
	cost = 2
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/ammo/pistolaps
	name = "Ammo Box - 9mm"
	desc = "An additional box of 9mm ammo. The box has 30 cases inside, does not come with a magazine."
	item = /obj/item/ammo_box/c9mm
	illegal_tech = FALSE

/datum/uplink_item/ammo/flechetteap
	name = "Armor Piercing Flechette Magazine"
	desc = "An additional 40-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with armor piercing flechettes that very nearly ignore armor, but are not very effective against flesh."
	item = /obj/item/ammo_box/magazine/flechette
	cost = 2
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/flechettes
	name = "Serrated Flechette Magazine"
	desc = "An additional 40-round flechette magazine; compatible with the Flechette Launcer. \
			Loaded with serrated flechettes that shreds flesh, but is stopped dead in its tracks by armor. \
			These flechettes are highly likely to sever arteries, and even limbs."
	item = /obj/item/ammo_box/magazine/flechette/s
	cost = 2
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/toydarts
	name = "Box of Riot Darts"
	desc = "A box of 40 Donksoft riot darts, for reloading any compatible foam dart magazine. Don't forget to share!"
	item = /obj/item/ammo_box/foambox/riot
	cost = 2
	surplus = 0
	illegal_tech = FALSE

/datum/uplink_item/ammo/bioterror
	name = "Box of Bioterror Syringes"
	desc = "A box full of preloaded syringes, containing various chemicals that seize up the victim's motor \
			and broca systems, making it impossible for them to move or speak for some time."
	item = /obj/item/storage/box/syndie_kit/bioterror
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS | UPLINK_SYNDICATE

/datum/uplink_item/ammo/bolt_action
	name = "Surplus Rifle Clip"
	desc = "A stripper clip used to quickly load bolt action rifles. Contains 5 rounds."
	item = /obj/item/ammo_box/a762
	cost = 1
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/bolt_action_bulk
	name = "Surplus Rifle Clip Box"
	desc = "An ammo box we found in a warehouse, holding 7 clips of 5 rounds for bolt-action rifles. Yes, the cheap ones."
	item = /obj/item/storage/toolbox/ammo
	cost = 4
	purchasable_from = (UPLINK_NUKE_OPS | UPLINK_SYNDICATE)

/datum/uplink_item/ammo/dark_gygax/bag
	name = "Dark Gygax Ammo Bag"
	desc = "A duffel bag containing ammo for three full reloads of the incendiary carbine and flash bang launcher that are equipped on a standard Dark Gygax exosuit."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/dark_gygax
	cost = 4
	purchasable_from = UPLINK_SYNDICATE

/datum/uplink_item/ammo/mauler/bag
	name = "Mauler Ammo Bag"
	desc = "A duffel bag containing ammo for three full reloads of the LMG, scattershot carbine, and SRM-8 missile laucher that are equipped on a standard Mauler exosuit."
	item = /obj/item/storage/backpack/duffelbag/syndie/ammo/mauler
	cost = 6
	purchasable_from = UPLINK_SYNDICATE

/datum/uplink_item/ammo/hermes/bag
	name = "Hermes Ammo Bag"
	desc = "A duffel bag containing ammo for three full reloads of the incendiary carbine and flash bang launcher that are equipped on a standard Hermes exosuit."
	item = /obj/item/storage/backpack/duffelbag/syndie/inteq/ammo/hermes
	cost = 4
	purchasable_from = UPLINK_NUKE_OPS

/datum/uplink_item/ammo/ares/bag
	name = "Ares Ammo Bag"
	desc = "A duffel bag containing ammo for three full reloads of the LMG, scattershot carbine, and SRM-8 missile laucher that are equipped on a standard Ares exosuit."
	item = /obj/item/storage/backpack/duffelbag/syndie/inteq/ammo/ares
	cost = 6
	purchasable_from = UPLINK_NUKE_OPS
