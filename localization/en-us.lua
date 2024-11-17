return {
	["misc"] = {
		["dictionary"] = {
			["k_rotten_ex"] = "Rotten!",
			["k_buried_ex"] = "Buried!",
			["k_invalid_ex"] = "Invalid!",
			["k_blam_ex"] = "Blam!",
			["k_dig_ex"] = "Dig.",
			["k_colony"] = "",
			["Chips"] = "Chips",
			},
		["poker_hands"] = {
			["dead"] = "Dead Man's Hand",
			["tma_dead"] = "Dead Man's Hand",
		},
		["poker_hand_descriptions"] = {
			["dead"] = {
				"2 Pairs of Black Aces and Black Eights, with",
				"a Gunslinger in the deck",
			},
			["tma_dead"] = {
				"2 Pairs of Black Aces and Black Eights, with",
				"a Gunslinger in the deck",
			},
		}
	},
	["descriptions"] = {
		["Tarot"] = {
			["c_tma_the_rot"] = {
				["name"] = "The Rot",
				["text"] = {
					"Creates {C:attention}1{} random",
					"{C:dark_edition}Negative {C:tarot}Tarot{} card"
				},
			}
		},
		["Spectral"] = {
			["c_tma_decay"] = {
				["name"] = "Decay",
				["text"] = {
					"Create a {C:dark_edition}Negative",
					"{C:attention} perishable{} copy",
					"of a random {C:attention}Joker"
				},
			}
		},
		["Planet"] = {
			["c_tma_colony"] = {
				["name"] = "Colony",
				["text"] = {
					"Upgrade most played",
					"{C:attention} poker hand{} ",
					"by {C:attention}1{} level"
				},
			}
		},
		["Enhanced"] = {
			["m_tma_rotting"] = {
				["name"] = "Rotting Card",
				["text"] = {
					"{C:mult}+#1#{} Mult",
					"Loses {C:mult}+#2#{} Mult",
					"when played"
				}
			}
		},
		["Joker"] = {
			["j_tma_NowhereToGo"] = {
				["name"] = "Dig.",
				["text"] = {
					"Reduces {C:attention}Blind Requirement{}",
					"by {C:white,X:chips}#1#%{} for every {C:spades}Spade{}",
					"Card scored this round"
				},
			},
			["j_tma_PlagueDoctor"] = {
				["name"] = "Plague Doctor",
				["text"] = {
					"{C:purple}Rots{} all {C:attention}Consumable{} cards",
					"in your possession at ",
					"the end of the {C:attention}shop"
				},
			},
			["j_tma_BlindSun"] = {
				["name"] = "Eclipse",
				["text"] = {
					"{C:green}#1# in #2#{} cards are",
					"drawn face down,",
					"Face down cards give",
					"{C:mult}+#3#{} Mult when scored"
				},
			},
			["j_tma_LightlessFlame"] = {
				["name"] = "Lightless Flame",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"destroy {C:attention}consumable{} cards",
					"in possesion and gain",
					"{C:mult}+#2#{} Mult for each",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
				},
			},
			["j_tma_LastLaugh"] = {
				["name"] = "Last Laugh",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult if there",
					"are no more",
					"cards in {C:attention}deck{}"
				},
			},
			["j_tma_Panopticon"] = {
				["name"] = "Panopticon",
				["text"] = {
					"{C:chips}+#1#{} Chips per unique",
					"{C:spectral}Spectral{} card",
					"used this run",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
				},
			},
			["j_tma_Boneturner"] = {
				["name"] = "Boneturner",
				["text"] = {
					"{C:attention}Kings{}, {C:attention}Queens{}, and",
					"{C:attention}Jacks{} are considered",
					"as the same {C:attention}Rank{}",
					"{C:inactive, s:0.8}(May not work with other mods)"
				},
			},
			["j_tma_FallenTitan"] = {
				["name"] = "Fallen Titan",
				["text"] = {
					"Each {C:attention}Stone{} card held",
					"in hand give {C:chips}+#1#{} Chips"
				},
			},
			["j_tma_Lonely"] = {
				["name"] = "Lonely Joker",
				["text"] = {
					"This Joker gains {C:mult}+#1#{} Mult",
					"if played hand is {C:attention}#3#{}",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
				},
			},
			["j_tma_Distortion"] = {
				["name"] = "Distortion",
				["text"] = {
					"{C:chips,E:1}It{E:1} is not what {C:chips,E:1}it{E:1} is"
				},
			},
			["j_tma_Nikola"] = {
				["name"] = "Nikola",
				["text"] = {
					"Retriggers all",
					"{C:red}Rare {C:attention}Jokers{}"
				},
			},
			["j_tma_Hunter"] = {
				["name"] = "Hunter",
				["text"] = {
					"Played {C:attention}Sealed{} cards",
					"Give {C:money}$#1#{} when scored"
				}
			},
			["j_tma_MrSpider"] = {
				["name"] = "Mr. Spider",
				["text"] = {
					"If hand is a single {C:attention}#3#{},",
					"destroy it and gain {C:white,X:mult}X#1#{} Mult,",
					"{s:0.8}Rank changes every round",				
					"{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)",
				}
			},
			["j_tma_Extinction"] = {
				["name"] = "The Extinction",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult if your",
					"full deck has less",
					"than {C:attention}#2#{} cards"
				}
			},
			["j_tma_Piper"] = {
				["name"] = "Pied Piper",
				["text"] = {
					"{C:attention}+#1#{} hand size,",
					"Discard {C:attention}#2#{} random cards",
					"when hand is played"
				}
			},
			["j_tma_Coffin"] = {
				["name"] = "Coffin",
				["text"] = {
					"Gives {C:money}$#1#{} when bought,",
					"Destroys leftmost Joker",
					"when sold"
				}
			},
			["j_tma_Syringe"] = {
				["name"] = "Syringe",
				["text"] = {
					"{C:attention}Sell{} this card to set",
					"{C:blue}hands{} to 1 and reduce",
					"{C:attention}Blind Requirement{} by {X:chips,C:white}80%{}"
				}
			},
			["j_tma_ShadowPuppet"] = {
				["name"] = "Shadow Puppet",
				["text"] = {
					"Creates a {C:dark_edition}Negative{} copy",
					"of the first {C:tarot}Tarot{} card",
					"used each round"
				}
			},
			["j_tma_Wildfire"] = {
				["name"] = "Wildfire",
				["text"] = {
					"{C:green}#1# in #2#{} {C:attention}Wild{} Cards",
					"convert adjacent cards",
					"after scoring"
				}
			},
			["j_tma_Gunslinger"] = {
				["name"] = "Gunslinger",
				["text"] = {
					"{C:attention}#1#{} counts as a",
					"{C:attention}Dead Man's Hand{}",
					"{C:red,E:2}Self Destructs{}"
				}
			},
			["j_tma_MechanicalJoker"] = {
				["name"] = "Mechanical Joker",
				["text"] = {
					"{C:attention}Retriggers{} adjacent",
					"common Jokers",
				}
			},
			["j_tma_Archivist"] = {
				["name"] = "Archivist",
				["text"] = {
					"When {C:attention}Consumable{} is used,",
					"adds {C:chips}Chips{} equal to {C:attention}four",
					"{C:attention}times{} the card's Sell Value",
					"to this card's {C:chips}Chips}",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
				}
			},
			["j_tma_Heartbeat"] = {
				["name"] = "Pulse",
				["text"] = {
					"{C:attention}Retriggers{} every",
					"other {C:heart}Heart{} card",
				}
			},
			["j_tma_LostCity"] = {
				["name"] = "Lost City",
				["text"] = {
					"{C:red}#1#{} Discard each round,",
					"{C:red}+#2#{} Discard if discarded",
					"Hand contains a {C:attention}Gold{} Card"
				}
			},
			["j_tma_Lighthouse"] = {
				["name"] = "Lighthouse",
				["text"] = {
					"{C:attention}Enhanced{} cards",
					"cannot be {C:attention}Debuffed{}",
				}
			},
			["j_tma_WarChant"] = {
				["name"] = "War Chant",
				["text"] = {
					"{C:mult}+#1#{} Mult if played",
					"hand is first hand of round",
				}
			},
			["j_tma_Fractal"] = {
				["name"] = "Fractal",
				["text"] = {
					"{C:club}Club{} cards give",
					"{C:white,X:mult}X#1#{} Mult for each",
					"scoring {C:club}Club{} card played."
				}
			},
			["j_tma_Mannequin"] = {
				["name"] = "Mannequin",
				["text"] = {
					"{C:attention}Sell{} this card to",
					"create a copy of the",
					"last removed Joker",
					"{s:0.8}Excluding {C:attention,s:0.8}Mannequin",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive})"
				}
			},
			["j_tma_DeepBlue"] = {
				["name"] = "Deep Blue",
				["text"] = {
					"Cards {C:attention}held in",
					"hand give {C:chips}Chips{}"
				}
			},
			["j_tma_Marionette"] = {
				["name"] = "Marionette",
				["text"] = {
					"{C:mult}+#1#{} Mult each time",
					"the {C:attention}Joker to",
					"the left triggers",
				}
			},
		},
	},
}