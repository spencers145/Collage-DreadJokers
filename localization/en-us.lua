return {
	["misc"] = {
		["dictionary"] = {
			["k_rotten_ex"] = "Rotten!",
			["k_colony"] = "",
			["Chips"] = "Chips"
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
				["name"] = "Dig",
				["text"] = {
					"This Joker gains {X:mult,C:white}X#2#{} Mult",
					"for every {C:spades}Spade{} Card",
					"scored this round",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
				},
			},
			["j_tma_PlagueDoctor"] = {
				["name"] = "Plague Doctor",
				["text"] = {
					"{C:purple}Rots{} all {C:attention}consumable{} cards",
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
					"When blind is selected,",
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
					"{C:inactive, S:0.8}(May not work with other mods)"
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
					"Retriggers all {C:red}Rare {C:attention}Jokers{}"
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
			}
		},
	},
}
