--- STEAMODDED HEADER
--- MOD_NAME: The Dread Jokers
--- MOD_ID: FearJokers
--- PREFIX: tma
--- MOD_AUTHOR: [LunaAstraCassiopeia, AnneBean]
--- MOD_DESCRIPTION: Some Jokers inspired by the Magnus Archives podcast
--- BADGE_COLOR: 56A786
--- VERSION: 1.0.4

----------------------------------------------
------------MOD CODE -------------------------



    SMODS.Atlas({
        key = 'tma_tarot',
        path = 'Tarots.png',
        px = 71,
        py = 95
    })
    SMODS.Atlas({
        key = 'tma_joker',
        path = 'Jokers.png',
        px = 71,
        py = 95
    })
    SMODS.Atlas({
        key = 'modicon',
        path = 'modicon.png',
        px = '34',
        py = '34'
    })

    -- Adding Jokers
    local card_add_deck = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        if not self.added_to_deck then
            if self.ability.name == 'j_tma_Piper' then
                G.hand:change_size(self.ability.extra.h_size)
            end
        end
        return card_add_deck(self, from_debuff)
    end
    -- Losing Jokers
    local card_remove_deck = Card.remove_from_deck
    function Card:remove_from_deck(from_debuff)
        if self.added_to_deck then
            if self.ability.name == 'j_tma_Piper' then
                G.hand:change_size(-self.ability.extra.h_size)
            end
        end
        return card_remove_deck(self, from_debuff)
    end

    -- Cool Straights :))))
    local cool_get_straight = get_straight
    function get_straight(hand)
        if not next(SMODS.find_card("j_tma_Boneturner")) then return cool_get_straight(hand) end
        local ret = {}
        local four_fingers = next(find_joker('Four Fingers'))
        if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
        local t = {}
        local IDS = {}
        local face_replace = next(find_joker('j_tma_Boneturner'))
        for i=1, #hand do
            local id = hand[i]:get_id()
            if id > 1 and id < 15 then
                if IDS[id] then
                    IDS[id][#IDS[id]+1] = hand[i]
                else
                    IDS[id] = {hand[i]}
                end
            end
        end
    
        local straight_length = 0
        local straight = false
        local can_skip = next(find_joker('Shortcut')) 
        local skipped_rank = false
        for j = 1, 14 do
        if IDS[j == 1 and 14 or j] then
            straight_length = straight_length + 1
            skipped_rank = false
            for k, v in ipairs(IDS[j == 1 and 14 or j] or {}) do
                t[#t+1] = v
            end
        elseif (j >= 11 and j <= 13 and (IDS[11] or IDS[12] or IDS[13]) and face_replace) then
            straight_length = straight_length + 1
            skipped_rank = false
            for k, v in ipairs(IDS[j == 1 and 14 or j] or {}) do
                t[#t+1] = v
            end
        elseif can_skip and not skipped_rank and j ~= 14 then
            skipped_rank = true
        else
            straight_length = 0
            skipped_rank = false
            if not straight then t = {} end
            if straight then break end
            end
            if straight_length >= (5 - (four_fingers and 1 or 0)) then straight = true end 
        end
        if not straight then return ret end
        table.insert(ret, t)
        return ret
        end
    end

    local local_generate_UIBox_ability_table = Card.generate_UIBox_ability_table
    function Card:generate_UIBox_ability_table()
        local card_type, hide_desc = self.ability.set or "None", nil
        local loc_vars = nil
        local main_start, main_end = nil,nil
        local no_badge = nil
        if not next(SMODS.find_card("j_tma_Distortion")) then return local_generate_UIBox_ability_table(self) end
        if card_type == 'Default' or card_type == 'Enhanced' then
            if ((self.ability.bonus or 0)  + (self.ability.perma_bonus or 0)) > 0 then
                loc_vars = { playing_card = not not self.base.colour, value = self.base.value, suit = self.base.suit, colour = self.base.colour,
                            nominal_chips = '???',
                            bonus_chips = '???' }
            else 
                loc_vars = { playing_card = not not self.base.colour, value = self.base.value, suit = self.base.suit, colour = self.base.colour,
                            nominal_chips = '???',
                            bonus_chips = nil }
            end
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then badges[#badges + 1] = string.lower(self.seal)..'_seal' end
            if self.ability.eternal then badges[#badges + 1] = 'eternal' end
            if self.ability.perishable then
                loc_vars = loc_vars or {}; loc_vars.perish_tally=self.ability.perish_tally
                badges[#badges + 1] = 'perishable'
            end
            if self.ability.rental then badges[#badges + 1] = 'rental' end
            if self.pinned then badges[#badges + 1] = 'pinned_left' end
            if self.sticker or ((self.sticker_run and self.sticker_run~='NONE') and G.SETTINGS.run_stake_stickers)  then loc_vars = loc_vars or {}; loc_vars.sticker=(self.sticker or self.sticker_run) end
    
            return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
        else
            return local_generate_UIBox_ability_table(self)
        end
    end

    local local_chip_bonus = Card.get_chip_bonus
    function Card:get_chip_bonus()
        if self.debuff then return 0 end
        if next(SMODS.find_card("j_tma_Distortion")) then
            local temp_Chips = pseudorandom('Distortion', (0 + ((self.ability.bonus or 0) + (self.ability.perma_bonus or 0))/2), (30 + 2*((self.ability.bonus or 0) + (self.ability.perma_bonus or 0))))
            return temp_Chips
        else 
            return local_chip_bonus(self)
        end
    end

    -- cool x of a kindsss :D
    local cool_get_X_same = get_X_same
    function get_X_same(num, hand, or_more)
        if not next(SMODS.find_card("j_tma_Boneturner")) then return cool_get_X_same(num, hand, or_more) end
        local vals = {}
        for i = 1, SMODS.Rank.max_id.value do
            vals[i] = {}
        end
        for i=#hand, 1, -1 do
            local curr = {}
            table.insert(curr, hand[i])
            for j=1, #hand do
                if hand[i]:get_id() == hand[j]:get_id() and i ~= j then
                    table.insert(curr, hand[j])
                elseif hand[i]:get_id() >= 11 and hand[i]:get_id() <= 13 and hand[j]:get_id() >= 11 and hand[j]:get_id() <= 13 and i ~= j then
                    table.insert(curr, hand[j])
                end
            end
            if or_more and (#curr >= num) or (#curr == num) then
                if curr[1]:get_id() >= 11 and curr[1]:get_id() <= 13 then
                    vals[13] = curr
                else
                    vals[curr[1]:get_id()] = curr
                end
            end
        end
        local ret = {}
        for i=#vals, 1, -1 do
            if next(vals[i]) then table.insert(ret, vals[i]) end
        end
        return ret
    end
    
    --[[ Wild Faces
    local card_get_id = Card.get_id
    function Card:get_id()
        local id = card_get_id(self)
        if id == 11 or id == 12 or id == 13 then
            if next(find_joker('j_tma_Boneturner')) then
                return 1006
            end
        end
        return card_get_id(self)
    end
    
    local card_is_face = Card.is_face
    function Card:is_face(from_boss)
        local id = self:get_id()
        if id == 1006 then
            return true
        end
        return card_is_face(self, from_boss)
    end ]]--
        
    
    --[[local card_is_suit = Card.get_id
    function Card:is_suit(suit, bypass_debuff, flush_calc)
        if self:is_face() then
            if flush_calc then
                if next(find_joker('j_tma_Boneturner')) then
                    return true
                end
            else
                if next(find_joker('j_tma_Boneturner')) then
                    return true
                end
            end
        end
        return card_is_suit(self, suit, bypass_debuff, flush_calc)
    end ]]--

    --NowhereToGo
    SMODS.Joker({
        key = 'NowhereToGo', atlas = 'tma_joker', pos = {x = 0, y = 0}, rarity = 2, cost = 7, blueprint_compat = true, 
        config = {
            x_mult = 1,
            extra = {
                mult_mod = 0.2,
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.x_mult, card.ability.extra.mult_mod}
            }
        end,
        calculate = function(self,card,context)
            if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
                card.ability.x_mult = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            elseif SMODS.end_calculate_context(context) and card.ability.x_mult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                    Xmult_mod = card.ability.x_mult
                }
            end
            if context.individual and not context.blueprint and context.cardarea == G.play and context.other_card:is_suit("Spades") then
                card.ability.x_mult = card.ability.x_mult + card.ability.extra.mult_mod
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex')},
                    card = card,
                    colour = G.C.RED
                }
            end
        end
    })
    
    -- Plague Doctor
    SMODS.Joker({
        key = 'PlagueDoctor', atlas = 'tma_joker', pos = {x = 1, y = 0}, rarity = 2, cost = 5, blueprint_compat = false, 
        calculate = function(self,card,context)
            if context.ending_shop then
                for k, v in ipairs(G.consumeables.cards) do
                    if v.ability.set == 'Tarot' and v.key ~= "c_tma_the_rot" then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.3,
                            func = (function()
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_rotten_ex'), colour = G.C.PURPLE, card = v})
                                v:juice_up(0.8, 0.8)
                                card:juice_up()
                                v:set_ability(G.P_CENTERS["c_tma_the_rot"])
                                return true
                            end)
                        }))
                    elseif v.ability.set == 'Planet' and v.key ~= "c_tma_colony" then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.3,
                            func = (function()
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_rotten_ex'), colour = G.C.PURPLE, card = v})
                                v:juice_up(0.8, 0.8)
                                card:juice_up()
                                v:set_ability(G.P_CENTERS["c_tma_colony"])
                                return true
                            end
                        )}))
                    elseif v.ability.set == 'Spectral' and v.key ~= "c_tma_decay" then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.3,
                            func = (function()
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_rotten_ex'), colour = G.C.PURPLE, card = v})
                                v:juice_up(0.8, 0.8)
                                card:juice_up()
                                v:set_ability(G.P_CENTERS["c_tma_decay"])
                                return true
                            end
                        )}))
                    end 
                end
                return
            end
        end
    })
    --Blind Sun 
    SMODS.Joker({
        key = 'BlindSun', atlas = 'tma_joker', pos = {x = 2, y = 0}, rarity = 2, cost = 8, blueprint_compat = true, 
        name = 'tma_BlindSun',
        config = {
            name = 'tma_BlindSun',
            mult = 20,
            extra = {
                odds = 7,
                card_list = {}
            }
        },
        loc_vars = function(self,info_queue,card)
            local vars
            if G.GAME and G.GAME.probabilities.normal then
                vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.mult}
            else
                vars = {1, card.ability.extra.odds, card.ability.mult}
            end
            return {vars = vars}
        end,
        calculate = function(self, card, context)
            if context.stay_flipped and not context.blueprint then
                card:juice_up(0.3)
            end
            if context.play_cards then
                card.ability.extra.card_list = {}
                for i = 1, #G.hand.highlighted do
                    if G.hand.highlighted[i].facing == 'back' then
                        table.insert(card.ability.extra.card_list, G.hand.highlighted[i])
                    end
                end
            end
            if context.individual and context.cardarea == G.play and context.other_card then
                for i = 1, #card.ability.extra.card_list do
                    local flipped_card = card.ability.extra.card_list[i]
                    if context.other_card == flipped_card then
                        return {
                            mult = card.ability.mult,
                            card = card
                        }
                    end
                end
            end
        end
    })
    
    -- Lightless Flame
    SMODS.Joker({
        key = 'LightlessFlame', atlas = 'tma_joker', pos = {x = 3, y = 0}, rarity = 1, cost = 4, blueprint_compat = true, perishable_compat = false,
        config = {
            mult_mod = 0,
            extra = {
                bonus_mult = 2,
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.mult_mod, card.ability.extra.bonus_mult}
            }
        end,
        calculate = function(self,card,context)
            if context.setting_blind and not card.getting_sliced and not context.blueprint then
                for k, v in ipairs(G.consumeables.cards) do
                    G.GAME.consumeable_buffer = 0
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.3,
                        func = function()
                        G.GAME.consumeable_buffer = 0
                        card:juice_up(0.8, 0.8)
                        v:start_dissolve()
                    return true end }))
                    card.ability.mult_mod = card.ability.mult_mod + card.ability.extra.bonus_mult
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.mult_mod}}, colour = G.C.RED, no_juice = true, card = card})
                end
                return
            end
            if SMODS.end_calculate_context(context) and card.ability.mult_mod > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                    mult_mod = card.ability.mult_mod
                }
            end
        end
    })

    -- Last Laugh
    SMODS.Joker({
        key = 'LastLaugh', atlas = 'tma_joker', pos = {x = 4, y = 0}, rarity = 2, cost = 6, blueprint_compat = true, 
        config = {
            extra = {
                woah_x_mult = 20
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.woah_x_mult}
            }
        end,
        calculate = function(self,card,context)
            if SMODS.end_calculate_context(context) and #G.deck.cards == 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.woah_x_mult}},
                    Xmult_mod = card.ability.woah_x_mult
                }
            end
        end
    })

    -- Extinction
    SMODS.Joker({
        key = 'Extinction', atlas = 'tma_joker', pos = {x = 4, y = 1}, rarity = 1, cost = 3, blueprint_compat = true, 
        config = {
            extra = {
                cool_x_mult = 5
            }
        },
        loc_vars = function(self,info_queue,card)
            return {vars = {card.ability.extra.cool_x_mult, (G.GAME.starting_deck_size or 52)/2}}
        end,
        calculate = function(self,card,context)
            if SMODS.end_calculate_context(context) and ((G.GAME.starting_deck_size)/2 - #G.playing_cards) > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.cool_x_mult}},
                    Xmult_mod = card.ability.extra.cool_x_mult
                }
            end
        end
    })

    -- Panopticon
    SMODS.Joker({
        key = 'Panopticon', atlas = 'tma_joker', pos = {x = 5, y = 0}, rarity = 3, cost = 7, blueprint_compat = true, 
        config = {
            extra = {
                chips = 0,
                chips_mod = 30
            }
        },
        loc_vars = function(self,info_queue,card)
            local spectrals_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectrals_used = spectrals_used + 1 end end
            return {vars = {card.ability.extra.chips_mod, spectrals_used*card.ability.extra.chips_mod}}
        end,
        calculate = function(self,card,context)
            if SMODS.end_calculate_context(context) then
                local spectrals_used = 0
                for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Spectral' then spectrals_used = spectrals_used + 1 end end
                if spectrals_used > 0 then
                    return {
                        message = localize{type='variable',key='a_chips',vars={spectrals_used*card.ability.extra.chips_mod}},
                        chips_mod = spectrals_used*card.ability.extra.chips_mod
                    }
                end
            end
        end
    })

    -- Boneturner
    SMODS.Joker({
        key = 'Boneturner', atlas = 'tma_joker', pos = {x = 6, y = 0}, rarity = 3, cost = 8, blueprint_compat = false
    })

    -- Hunter
    SMODS.Joker({
        key = 'Hunter', atlas = 'tma_joker', pos = {x = 3, y = 1}, rarity = 2, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                money = 3
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.money}
            }
        end,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play and context.other_card:get_seal() then
                print("test!")
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            end
        end
    })
    
    -- Lonely Joker
    SMODS.Joker({
        key = 'Lonely', atlas = 'tma_joker', pos = {x = 8, y = 0}, rarity = 1, cost = 5, blueprint_compat = true, perishable_compat = false,
        config = {
            mult_mod = 0,
            extra = {
                mult_bonus = 2
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.mult_bonus, card.ability.mult_mod, localize('High Card', 'poker_hands')}
            }
        end,
        calculate = function(self,card,context)
            if context.before and not context.blueprint and context.scoring_name == 'High Card' then
                card.ability.mult_mod = card.ability.mult_mod + card.ability.extra.mult_bonus
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    card = card
                }
            end
            if SMODS.end_calculate_context(context) and card.ability.mult_mod > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.mult_mod}},
                    mult_mod = card.ability.mult_mod
                }
            end
        end
    })
    
    -- Piper
    SMODS.Joker({
        key = 'Piper', atlas = 'tma_joker', pos = {x = 5, y = 1}, rarity = 2, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                h_size = 2,
                discard_rand = 2
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.h_size, card.ability.extra.discard_rand}
            }
        end,
        calculate = function(self,card,context)
            if context.before then
                G.E_MANAGER:add_event(Event({ func = function()
                    local any_selected = nil
                    local _cards = {}
                    for k, v in ipairs(G.hand.cards) do
                        _cards[#_cards+1] = v
                    end
                    for i = 1, 2 do
                        if G.hand.cards[i] then 
                            local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
                            G.hand:add_to_highlighted(selected_card, true)
                            table.remove(_cards, card_key)
                            any_selected = true
                            play_sound('card1', 1)
                        end
                    end
                    card:juice_up()
                    if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
                return true end }))
            end
        end
    })

    -- Distortion
    SMODS.Joker({
        key = 'Distortion', atlas = 'tma_joker', pos = {x = 9, y = 0}, rarity = 1, cost = 4, blueprint_compat = false
    })

    -- Nikola Orsinov
    SMODS.Joker({
        key = 'Nikola', atlas = 'tma_joker', pos = {x = 0, y = 1}, soul_pos = {x = 1, y = 1}, rarity = 4, cost = 20, blueprint_compat = false,
        calculate = function(self,card,context)
            if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center.rarity == 3 and context.other_card ~= self then
				return {
					message = localize('k_again_ex'),
					repetitions = self.config.num_retriggers,
					card = card
				}
		    end
        end
    })

    -- Fallen Titan
    SMODS.Joker({
        key = 'FallenTitan', atlas = 'tma_joker', pos = {x = 7, y = 0}, rarity = 2, cost = 7, blueprint_compat = true, 
        config = {
            extra = {
                bonus_chips = 30
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.bonus_chips}
            }
        end,
        calculate = function(self,card,context)
            if not context.end_of_round and context.individual and context.cardarea == G.hand and context.other_card.ability.name == "Stone Card" then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        card = card,
                        chips = card.ability.extra.bonus_chips
                    }
                end
            end
        end
    })

    -- Mr Spider
    SMODS.Joker({
        key = 'MrSpider', atlas = 'tma_joker', pos = {x = 2, y = 1}, rarity = 2, cost = 7, blueprint_compat = true, 
        config = {
            x_mult = 1,
            extra = {
                bonus_mult = 0.5,
                rank = 'Jack'
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.bonus_mult, card.ability.x_mult, localize(card.ability.extra.rank, 'ranks')}
            }
        end,
        set_ability = function(self, card)
            if G.playing_cards and #G.playing_cards > 0 then
                local ranks_in_deck = {}
                for _, v in ipairs(G.playing_cards) do
                    table.insert(ranks_in_deck, v)
                end
                card.ability.extra.rank = pseudorandom_element(ranks_in_deck, pseudoseed('mrspider')).base.value
            end
        end,
        calculate = function(self,card,context)
            if context.end_of_round then
                local ranks_in_deck = {}
                for _, v in ipairs(G.playing_cards) do
                    table.insert(ranks_in_deck, v)
                end
                card.ability.extra.rank = pseudorandom_element(ranks_in_deck, pseudoseed('mrspider')).base.value
            end
            if SMODS.end_calculate_context(context) and card.ability.x_mult > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.x_mult}},
                    Xmult_mod = card.ability.x_mult
                }
            end
            if context.destroying_card and not context.blueprint and (context.full_hand[1].base.value == card.ability.extra.rank or ((context.full_hand[i].base.value == 'Jack' or context.full_hand[i].base.value == 'Queen' or context.full_hand[i].base.value == 'King') and next(find_joker('j_tma_Boneturner')) and card.ability.extra.rank == 'Jack' or card.ability.extra.rank == 'Queen' or card.ability.extra.rank == 'King')) and #context.full_hand == 1 then
                local playcard = context.full_hand[1]
                card.ability.x_mult = card.ability.x_mult + card.ability.extra.bonus_mult
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_mult}}, colour = G.C.RED, card = card})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						playcard:start_dissolve()
					return true
				end}))
                return true
            end
        end
    })
    
    -- The Rot (Tarot)
    SMODS.Consumable {
        set = 'Tarot', atlas = 'tma_tarot', key = 'the_rot', consumable = true,
        pos = { x = 0, y = 0 },
        config = {tarots = 1}, hidden = true,
        can_use = function(self, card)
            return true
        end,
        in_pool = function(self)
            return false
        end,
        loc_vars = function(self) return {vars = {self.config.tarots}} end, cost_mult = 1.0, effect = "Round Bonus",
        use = function(self, card, area,copier)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'rot')
                    new_card:set_cost(0)
                    new_card:set_edition({negative = true}, true)
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    card:juice_up(0.3, 0.5)
                end
                return true end }))
            delay(0.6)
        end
    }

    
    --[[
    SMODS.Enhancement {
        set = 'Enhanced', atlas = 'tma_tarot', key = 'rotting',
        pos = {x=0,y=1},
        config = {mult = 20, lose_mult = 5},
        loc_vars = function(self) return {vars = {self.config.mult, self.config.lose_mult}} end,
        calculate = function(self, card, context, effect)
            if context.cardarea == G.play and not context.repetition then
                SMODS.eval_this(card, {
                    mult_mod = self.config.mult,
                    message = localize({type = 'variable', key = 'a_mult', vars = {self.config.mult}}),
                })
            elseif context.discard then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        self.config.mult = self.config.mult - self.config.lose_mult
                        return true
                    end)}))
                card_eval_status_text(self, 'variable', nil, nil, nil, {message = localize({key = 'a_minus_mult', type = 'variable', vars = {self.config.mult}}), colour = G.C.PURPLE})
            end
        end
    }
    ]]--
    -- Colony (Planet)
    local planet_q = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_planet_q'), get_type_colour(self or card.ability, card), nil, 1.2)
    end
    SMODS.Consumable {
        set = 'Planet', atlas = 'tma_tarot', key = 'colony',
        pos = { x = 1, y = 0 },hidden = true,
        set_card_type_badge = planet_q,
        can_use = function(self, card)
            return true
        end,
        in_pool = function(self)
            return false
        end,
        use = function(self, card, area, copier)
            local used_consumable = copier or card
            --Get most played hand type (logic yoinked from Telescope)
            local _planet, _hand, _tally = nil, nil, -1
            for k, v in ipairs(G.handlist) do
                if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            if _hand then
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == _hand then
                        _planet = v.key
                    end
                end
            end
            update_hand_text(
                { sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
                {
                    handname = localize(_hand, "poker_hands"),
                    chips = G.GAME.hands[_hand].chips,
                    mult = G.GAME.hands[_hand].mult,
                    level = G.GAME.hands[_hand].level,
                }
            )
            level_up_hand(used_consumable, _hand, false, 1)
            update_hand_text(
                { sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
                { mult = 0, chips = 0, handname = "", level = "" }
            )
        end,
    }
    -- Decay (Spectral)
    SMODS.Consumable {
        set = 'Spectral', atlas = 'tma_tarot', key = 'decay',
        pos = { x = 2, y = 0 }, hidden = true,
        can_use = function(self, card)
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and G.jokers.config.card_limit > 1 then 
                    return true
                end
            end
        end,
        in_pool = function(self)
            return false
        end,
        use = function(self, card, area, copier)
            local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('decay_choice'))
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.4, func = function()
                local new_card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                new_card:start_materialize()
                new_card:add_to_deck()
                local new_edition = {negative = true}
                new_card:set_edition(new_edition, true)
                if new_card.ability.eternal then
                    SMODS.Stickers['eternal']:apply(new_card, false)
                end
                SMODS.Stickers['perishable']:apply(new_card, true, 5)
                G.jokers:emplace(new_card)
                return true end }))
        end,
    }

----------------------------------------------
------------MOD CODE END----------------------
