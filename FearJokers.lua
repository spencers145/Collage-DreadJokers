--- STEAMODDED HEADER
--- MOD_NAME: The Dread Jokers
--- MOD_ID: FearJokers
--- PREFIX: tma
--- MOD_AUTHOR: [LunaAstraCassiopeia]
--- MOD_DESCRIPTION: Some Jokers inspired by the Magnus Archives podcast
--- BADGE_COLOR: 56A786
--- VERSION: 1.1.1
--- DEPENDENCIES: [Talisman>=2.0.0-beta5]

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

    local function forced_message(message, card, color, delay, juice)
        if delay == true then
            delay = 0.7 * 1.25
        elseif delay == nil then
            delay = 0
        end
    
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = delay, func = function()
    
            if juice then card:juice_up(0.7) end
    
            card_eval_status_text(
                card,
                'extra',
                nil, nil, nil,
                {message = message, colour = color, instant = true}
            )
            return true
        end}))
    end

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
            if not from_debuff then
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.name == 'j_tma_Mannequin' and self.ability.name ~= 'j_tma_Mannequin' then 
                        v.ability.extra.last_sold = self
                    end
                    G.GAME.last_sold_joker = self
                end
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

    --NowhereToGo
    SMODS.Joker({
        key = 'NowhereToGo', atlas = 'tma_joker', pos = {x = 0, y = 0}, rarity = 2, cost = 7, blueprint_compat = true, 
        config = {
            extra = {
                percent_chips = 0.1,
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.percent_chips*100}
            }
        end,
        calculate = function(self,card,context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit("Spades") and not context.other_card.debuff then
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.2,func = function()
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1-card.ability.extra.percent_chips))
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate() 
                    chips_UI:juice_up()
            
                    if not silent then play_sound('chips1') end
                    return true end }))
                return {
                    extra = {message = localize('k_dig_ex'), colour = HEX("7a5830"), focus = card},
                    colour = HEX("7a5830"),
                    card = context.card
                }
            end
        end
    })
    
    -- Plague Doctor
    SMODS.Joker({
        key = 'PlagueDoctor', atlas = 'tma_joker', pos = {x = 1, y = 0}, rarity = 2, cost = 5, blueprint_compat = false, 
        calculate = function(self,card,context)
            if context.ending_shop and not context.blueprint then
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
            if context.individual and context.cardarea == G.play and context.other_card and not context.other_card.debuff then
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
        key = 'Panopticon', atlas = 'tma_joker', pos = {x = 5, y = 0}, rarity = 3, cost = 7, blueprint_compat = true, perishable_compat = false,
        config = {
            extra = {
                chips = 0,
                chips_mod = 40
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
        key = 'Nikola', atlas = 'tma_joker', pos = {x = 0, y = 1}, soul_pos = {x = 1, y = 1}, rarity = 4, cost = 20, blueprint_compat = true,
        calculate = function(self,card,context)
            if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center.rarity == 3 and context.other_card ~= card then
            return {
              message = localize('k_again_ex'),
              repetitions = 1,
              card = card
            }
          end
        end
    })

    -- Fallen Titan
    SMODS.Joker({
        key = 'FallenTitan', atlas = 'tma_joker', pos = {x = 7, y = 0}, rarity = 2, cost = 7, blueprint_compat = true, enhancement_gate = 'm_stone',
        config = {
            extra = {
                bonus_chips = 50
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
                    print("test!")
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
        key = 'MrSpider', atlas = 'tma_joker', pos = {x = 2, y = 1}, rarity = 2, cost = 7, blueprint_compat = true, perishable_compat = false,
        config = {
            x_mult = 1,
            extra = {
                bonus_mult = 0.25,
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

    -- Coffin
    SMODS.Joker({
        key = 'Coffin', atlas = 'tma_joker', pos = {x = 6, y = 1}, rarity = 1, cost = 1, blueprint_compat = false, eternal_compat = false,
        config = {
            extra = {
                dollars = 20,
                my_pos = nil
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.dollars}
            }
        end,
        add_to_deck = function(self, card, from_debuff)
            if not from_debuff then 
                ease_dollars(card.ability.extra.dollars)
            end
            local eval = function(card) return not card.REMOVED end
            juice_card_until(card, eval, true)
        end,
        calculate = function(self,card,context)
            if context.setting_blind and not context.blueprint then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            if context.selling_self and not context.blueprint then 
                local jokers = {}
                for i=1, #G.jokers.cards do 
                    if G.jokers.cards[i] ~= card then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                end
                if not from_debuff and #jokers > 0 then 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_buried_ex')})
                    local chosen_joker = ((G.jokers.cards[1]))
                    if not chosen_joker.ability.eternal then
                        chosen_joker.getting_sliced = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                            G.GAME.joker_buffer = 0
                            chosen_joker:start_dissolve({HEX("7a5830")}, nil, 1.6)
                            play_sound('slice1', 0.96+math.random()*0.08)
                        return true end }))
                    end
                end
            end
        end
    })

    -- Syringe
    SMODS.Joker({
        key = 'Syringe', atlas = 'tma_joker', pos = {x = 7, y = 1}, rarity = 2, cost = 5, blueprint_compat = false, eternal_compat = false,
        calculate = function(self,card,context)
            if context.selling_self and G.GAME.blind then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,func = function()
                    ease_hands_played((1-G.GAME.current_round.hands_left), nil, true)
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.2)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate() 
                    chips_UI:juice_up()
            
                    if not silent then play_sound('chips2') end
                return true end }))
            end
        end
    })

    -- Shadow Puppet
    SMODS.Joker({
        key = 'ShadowPuppet', atlas = 'tma_joker', pos = {x = 8, y = 1}, rarity = 3, cost = 8, blueprint_compat = true,
        config = {
            extra = {
                active = false
            }
        },
        calculate = function(self,card,context)
            if context.setting_blind then
                if not card.ability.extra.active then
                    card.ability.extra.active = true
                    local eval = function() return card.ability.extra.active end
                    juice_card_until(card, eval, true)
                end
            end
            if context.using_consumeable and card.ability.extra.active and context.consumeable.ability.set == 'Tarot' then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,func = function ()
                        local copy
                        card.ability.extra.active = false
                        copy = copy_card(context.consumeable)
                        copy:set_edition({negative = true}, true)
                        copy:set_cost(1)
                        copy:add_to_deck()
                        G.consumeables:emplace(copy)
                    return true
                end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
            end
        end
    })

    -- Wildfire 
    SMODS.Joker({
        key = 'Wildfire', atlas = 'tma_joker', pos = {x = 9, y = 1}, rarity = 2, cost = 5, blueprint_compat = true, enhancement_gate = 'm_wild',
        config = {
            extra = {
                odds = 6
            }
        },
        loc_vars = function(self,info_queue,card)
            local vars
            if G.GAME and G.GAME.probabilities.normal then
                vars = {G.GAME.probabilities.normal, card.ability.extra.odds}
            else
                vars = {1, card.ability.extra.odds}
            end
            return {vars = vars}
        end,
    })

    -- Gunslinger
    SMODS.Joker({
        key = 'Gunslinger', atlas = 'tma_joker', pos = {x = 0, y = 2}, rarity = 2, cost = 6, blueprint_compat = false,
        config = {
            extra = {
                hand = 'Two Pair'
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {localize(card.ability.extra.hand, 'poker_hands')}
            }
        end,
        set_ability = function(self, card)
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible then _poker_hands[#_poker_hands+1] = k end
            end
            local old_hand = card.ability.extra.hand
            card.ability.extra.hand = nil
    
            while not card.ability.extra.hand do
                card.ability.extra.hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_to_do' or 'to_do'))
            end
        end,
        calculate = function(self,card,context)
            if context.before and not context.blueprint and context.scoring_name == 'tma_dead' then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_blam_ex'), colour = G.C.RED, card = card})
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                })) 
                return true
            end
        end
    })

    -- Mechanical Joker
    SMODS.Joker({
        key = 'MechanicalJoker', atlas = 'tma_joker', pos = {x = 1, y = 2}, rarity = 3, cost = 8, blueprint_compat = true,
        calculate = function(self, card, context)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.config.center.rarity == 1 and context.other_card ~= card and (context.other_card == G.jokers.cards[i+1] or context.other_card == G.jokers.cards[i-1]) then
                    return {
                      message = localize('k_again_ex'),
                      repetitions = 1,
                      card = card
                    }
                    end
                end        
            end
        end
    })

    -- Archivist Joker
    SMODS.Joker({
        key = 'Archivist', atlas = 'tma_joker', pos = {x = 2, y = 2}, rarity = 1, cost = 5, blueprint_compat = true, perishable_compat = false,
        config = {
            extra = {
                chips = 0,
                gold = 1
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.chips, card.ability.extra.gold}
            }
        end,
        calculate = function(self, card, context)
            if context.using_consumeable and not context.blueprint then
                card.ability.extra.chips = card.ability.extra.chips + 4*context.consumeable.sell_cost
                G.E_MANAGER:add_event(Event({
                    func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}}); return true
                    end}))
                return
            end
            if context.end_of_round then 
                for k, v in ipairs(G.consumeables.cards) do
                    if v.set_cost then 
                        v.ability.extra_value = (v.ability.extra_value or 0) + self.ability.extra.gold
                        v:set_cost()
                    end
                end
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
            if SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chips_mod = card.ability.extra.chips
                }
            end
        end
    })

    -- Heartbeat
    SMODS.Joker({
        key = 'Heartbeat', atlas = 'tma_joker', pos = {x = 3, y = 2}, rarity = 2, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                repetitions = 1,
                active = true
            }
        },
        loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.repetitions}
            }
        end,
        calculate = function(self, card,context)
            if  context.repetition then
                if context.cardarea == G.play then
                    if context.other_card:is_suit("Hearts") then
                        if card.ability.extra.active then
                            card.ability.extra.active = false
                            return {
                                message = localize('k_again_ex'),
                                repetitions = card.ability.extra.repetitions,
                                card = card
                            }
                        else
                            card.ability.extra.active = true
                        end
                    end
                end
            end
            if context.before then
                card.ability.extra.active = true
            end
        end
    })
    
    --Lost City
    SMODS.Joker({
        key = 'LostCity', atlas = 'tma_joker', pos = {x = 4, y = 2}, rarity = 2, cost = 5, blueprint_compat = false, enhancement_gate = 'm_gold',
        config = {
            d_size = -1,
            extra = {
                discard_gain = 1
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {card.ability.d_size, card.ability.extra.discard_gain}
            }
        end,
        add_to_deck = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.d_size
            ease_discard(card.ability.d_size)
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.d_size
            ease_discard(-card.ability.d_size)
        end,
        calculate = function(self, card, context) 
            if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
                local gold = 0
                for k, v in ipairs(context.full_hand) do
                    if v.ability.name == "Gold Card" then gold = gold + 1 end
                end
                if gold > 0 then
                    ease_discard(card.ability.extra.discard_gain)
                    forced_message('+'..card.ability.extra.discard_gain..' '..localize('b_discard'), card, G.C.RED, true)
                end
            end
        end
    })
    
    -- Lighthouse
    SMODS.Joker({
        key = 'Lighthouse', atlas = 'tma_joker', pos = {x = 5, y = 2}, rarity = 1, cost = 5, blueprint_compat = false
    })

    -- War Chant
    SMODS.Joker({
        key = 'WarChant', atlas = 'tma_joker', pos = {x = 6, y = 2}, rarity = 1, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                mult_stuff = 30,
                active = false
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {card.ability.extra.mult_stuff}
            }
        end,
        calculate = function(self,card,context)
            if context.setting_blind then
                if not card.ability.extra.active then
                    card.ability.extra.active = true
                    local eval = function() return card.ability.extra.active end
                    juice_card_until(card, eval, true)
                end
            end
            if SMODS.end_calculate_context(context) and card.ability.extra.active then
                card.ability.extra.active = false
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_stuff}},
                    mult_mod = card.ability.extra.mult_stuff
                }
            end
        end
    })

    -- Fractal
    SMODS.Joker({
        key = 'Fractal', atlas = 'tma_joker', pos = {x = 7, y = 2}, rarity = 2, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                xmult_per = 0.1
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {card.ability.extra.xmult_per}
            }
        end,
        calculate = function(self,card,context)
            if context.individual and context.other_card:is_suit("Clubs") and context.cardarea == G.play then
                local clubs = 0
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_suit("Clubs") then
                        clubs = clubs + 1
                    end
                end
                local total_xmult = 1 + card.ability.extra.xmult_per*clubs
                return {
                    x_mult = total_xmult,
                    card = card
                }
            end
        end
    })

    -- Mannequin
    SMODS.Joker({
        key = 'Mannequin', atlas = 'tma_joker', pos = {x = 8, y = 2}, rarity = 1, cost = 2, blueprint_compat = false, eternal_compat = false,
        config = {
            extra = {
                last_sold = nil
            }
        },
        loc_vars = function(self, info_queue, card)
            if card.ability.extra.last_sold ~= nil and card.ability.extra.last_sold.ability.name ~= nil then
                local name_sold = card.ability.extra.last_sold.ability.name and G.P_CENTERS[card.ability.extra.last_sold.config.center_key] or nil
                return {
                    vars = {(name_sold and (localize{type = 'name_text', key = name_sold.key, set = name_sold.set}) or name_sold.ability.name)}
                }
            else
                if G.GAME.last_sold_joker ~= nil and G.GAME.last_sold_joker.ability.name ~= nil then
                    local name_sold = G.GAME.last_sold_joker.ability.name and G.P_CENTERS[G.GAME.last_sold_joker.config.center_key] or nil
                    return {
                        vars = {(name_sold and (localize{type = 'name_text', key = name_sold.key, set = name_sold.set}) or name_sold.ability.name)}
                    }
                else
                return { vars = {"N/A"}}
                end
            end
        end,
        calculate = function(self,card,context)
            if context.selling_self and not context.blueprint then  
                local jokers = {}
                for i=1, #G.jokers.cards do 
                    if G.jokers.cards[i] ~= card then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                end
                if #jokers > 0 then 
                    if #G.jokers.cards <= G.jokers.config.card_limit then 
                        if (card.ability.extra.last_sold ~= nil and card.ability.extra.last_sold.ability.name ~= nil) then
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                        local new_card = copy_card(card.ability.extra.last_sold, nil, nil, nil, card.ability.extra.last_sold.edition and card.ability.extra.last_sold.edition.negative)
                        new_card:start_materialize()
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        elseif G.GAME.last_sold_joker ~= nil and G.GAME.last_sold_joker.ability.name ~= nil then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                            local new_card = copy_card(G.GAME.last_sold_joker, nil, nil, nil, G.GAME.last_sold_joker.edition and G.GAME.last_sold_joker.edition.negative)
                            new_card:start_materialize()
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                        end

                    else
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
                    end
                else
            end
        end
    end
    })

    -- DeepBlue
    SMODS.Joker({
        key = 'DeepBlue', atlas = 'tma_joker', pos = {x = 9, y = 2}, rarity = 3, cost = 6, blueprint_compat = true,
        calculate = function(self,card,context)
            if not context.end_of_round and context.individual and context.cardarea == G.hand then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card,
                    }
                else
                    return {
                        card = card,
                        chips = context.other_card:get_chip_bonus()
                    }
                end
            end
        end

    })
    
    -- 
    SMODS.Joker({
        key = 'Marionette', atlas = 'tma_joker', pos = {x = 0, y = 3}, rarity = 1, cost = 6, blueprint_compat = true,
        config = {
            extra = {
                mult_mod = 5,
                triggers = 0,
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {card.ability.extra.mult_mod}
            }
        end,
        calculate = function(self,card,context)
            if context.post_trigger and not context.blueprint then
                local other_joker = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i-1] end
                end
                if context.other_joker == other_joker then
                    card.ability.extra.triggers = card.ability.extra.triggers + 1
                    return nil
                end
            end
            if SMODS.end_calculate_context(context) and card.ability.extra.triggers > 0 then
                local trigs = card.ability.extra.triggers or 0
                card.ability.extra.triggers = 0
                return {
                    mult_mod = card.ability.extra.mult_mod*trigs,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult_mod*trigs}},
                }
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
                    play_sound('timpani')
                    local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'rot')
                    new_card:set_edition({negative = true}, true)
                    new_card:add_to_deck()
                    new_card:set_cost(1)
                    G.consumeables:emplace(new_card)
                    card:juice_up(0.3, 0.5)
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

    -- Dead Man's Hand
    SMODS.PokerHandPart{
    key = 'deadhand',
    func = function(hand)
        local current_cards = {}
        local hands = {}
        local activated = false
        local deadhanded = false
        for i = 1, #hand do
            table.insert(current_cards, hand[i])
        end
        if G.jokers ~= nil then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_tma_Gunslinger' then
                    table.insert(hands, v.ability.extra.hand)
                    activated = true
                else
                    activated = false
                end
            end
        end
        local ace_black = 0
        local eight_black = 0
        for i = 1, #hand do
            if hand[i]:get_id() == 14 and (hand[i]:is_suit("Spades", nil, true) or hand[i]:is_suit("Clubs", nil, true)) then
                ace_black = ace_black+1
            elseif hand[i]:get_id() == 8 and (hand[i]:is_suit("Spades", nil, true) or hand[i]:is_suit("Clubs", nil, true)) then
                eight_black = eight_black+1
            end
        end

            if (eight_black >=2 and ace_black >=2 and activated) or deadhanded then
                return {hand}
            end
        return {}
    end
}

    SMODS.PokerHand{ -- Dead Man's Hand
        key = 'dead',
        above_hand = 'Flush Five',
        visible = false,
        chips = 1837,
        mult = 1876,
        l_chips = 0,
        l_mult = 0,
        example = {
            {'S_8', true},
            {'C_A', true},
            {'S_A', true},
            {'C_8', true}
        },
        evaluate = function(parts)
            if #parts._2 < 2 or not next(parts.tma_deadhand) then return {} end
            return { SMODS.merge_lists (parts._all_pairs, parts.tma_deadhand) }
        end
    }

    local evaluate_poker_hand_ref = evaluate_poker_hand
    function evaluate_poker_hand(hand)
        local ret = evaluate_poker_hand_ref(hand)
        local hands = {}
        if G.jokers ~= nil then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_tma_Gunslinger' then
                    table.insert(hands, v.ability.extra.hand)
                end
            end
        end
        for i = 1, #hands do
            for k, v in pairs(ret) do
                if hands[i] == k and v ~= nil then
                    ret["tma_dead"] = ret[k]
                end
            end
        end
        return ret
    end

    -- Statements

    SMODS.UndiscoveredSprite({
        key = 'Statement',
        atlas = 'tma_tarot',
        pos = {x = 0, y = 1},
    })

    SMODS.ConsumableType {
        key = 'Statement',
        primary_colour = HEX("5AC34D"),
        secondary_colour = HEX("7BA85D"),
        loc_txt = {
            name = "Statement",
            collection = "Statements",
            undiscovered = {
                name = 'Unknown Statement',
                text = {
                    'Find this tape in an unseeded',
                    'run to find out what it does'
                }
            }
        },
        collection_rows = {5, 5},
        shop_rate = 0.4
    }
    
    -- Nightfall
    SMODS.Consumable {
        set = 'Statement', atlas = 'tma_tarot', key = 'nightfall',
        pos = { x = 1, y = 1 },
        config = {extra = {active = false}},
        can_use = function(self, card)
            return not card.ability.extra.active
        end,
        use = function(self, card, area, copier)
            card.ability.extra.active = true
            local eval = function(card) return card.ability.extra.active end
            juice_card_until(card, eval, true)
        end,
        keep_on_use = function(self, card)
            return true
        end
    }

    -- Statement Ability

    local calc_joker = Card.calculate_joker

    function Card.calculate_joker(context)
        
        return calc_joker(self, context)
    end

----------------------------------------------
------------MOD CODE END----------------------