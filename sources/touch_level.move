/// Module: touch_level
module touch_assets::touch_level {
    use sui::package;
    use sui::display;
    use std::string::{utf8, String};
    use sui::table::{Self, Table};
    use sui::event;
    use sui::coin::{Self, Coin};
    use touch_assets::touch::{Self, TOUCH, TouchSupply};
    use touch_assets::admin::AdminCap;

    // Error
    const ELengthNotMatched: u64 = 1;
    const ENotEligible: u64 = 2;
    const ELevelTooLow: u64 = 3;

    // Event
    public struct TouchProfileClaimed has copy, drop {
        to: address,
    }

    // OTW
    public struct TOUCH_LEVEL has drop {}

    // For collecting addresses that can claim TouchProfile NFT
    public struct TouchEligible has key {
        id: UID,
        addrs: Table<address, u8>,
    } 

    // Amount of Coin<TOUCH> for upgrading NFT's level
    public struct TouchNeedForOneLevel has key {
        id: UID,
        // TODO: vec_map: different value for different level
        value: u64
    }

    // touch profile NFT object
    public struct TouchProfile has key, store {
        id: UID,
        fame: String,
        personality: String,
        level: u8,
        desc: String,  // personality basic description
        base_url: String,
    }

    fun init(otw: TOUCH_LEVEL, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url"),
        ];
        let values = vector[
            // name
            utf8(b"{fame} (lvl. {level})"),
            // description 
            utf8(b"Personality: {personality} -- Level: {level} -- {desc}"),
            // image_url
            utf8(b"{base_url}/{personality}-{level}-{fame}.svg"),
        ];

        let deployer = ctx.sender();
        let publisher = package::claim(otw, ctx);
        let mut display = display::new_with_fields<TouchProfile>(
            &publisher, keys, values, ctx
        );

        display.update_version();
        transfer::public_transfer(publisher, deployer);
        transfer::public_transfer(display, deployer);

        // init TouchEligible with empty table and share it
        let te_obj = TouchEligible {
            id: object::new(ctx),
            addrs: table::new(ctx),
        };
        transfer::share_object(te_obj);

        // init Touch Need for upgrading variables
        let tn_obj = TouchNeedForOneLevel {
            id: object::new(ctx),
            value: 10_000_000_000u64
        };
        transfer::share_object(tn_obj);
    }

    public fun mint(
        fame: String,
        personality: String, 
        level: u8, 
        desc: String,
        base_url: String,
        ctx: &mut TxContext
    ): TouchProfile {
        let tp = TouchProfile {
            id: object::new(ctx),
            fame,
            personality,
            level,
            desc,
            base_url,
        };
        tp
    }

    entry fun update_addrs(
        _: &AdminCap, 
        te: &mut TouchEligible, 
        addrs: vector<address>, 
        levels: vector<u8>
    ) {
        let (len, mut i) = (addrs.length(), 0u64);
        assert!(len == levels.length(), ELengthNotMatched);

        while (i < len) {
            if(te.addrs.contains(addrs[i])) {
                te.addrs.remove(addrs[i]);
            };
            te.addrs.add(addrs[i], levels[i]);
            i = i + 1;
        }
    }

    entry fun claim(
        te: &mut TouchEligible, 
        fame: String,
        personality: String, 
        desc: String,
        base_url: String,
        ctx: &mut TxContext
    ) {
        let sender = ctx.sender();
        assert!(te.addrs.contains(sender), ENotEligible);

        // remove sender account and get the NFT level
        let level = te.addrs.remove(sender);
        let touch_profile = mint(fame, personality, level, desc, base_url, ctx);
        
        // send to `to`
        transfer::public_transfer(touch_profile, sender);
        event::emit(TouchProfileClaimed { to: sender });
    }

    entry fun upgrade(
        tp: &mut TouchProfile, 
        te: &TouchNeedForOneLevel,
        tou_supply: &mut TouchSupply, 
        tou: &mut Coin<TOUCH>,
        fame: String,
        level: u8,
        ctx: &mut TxContext
    ) {
        assert!(tp.level < level, ELevelTooLow);
        // amount need to upgrade
        let amount_need = (level - tp.level) as u64 * te.value;
        let afford = tou.split(amount_need, ctx);
        let bal = coin::into_balance(afford);

        // upgrade NFT's level info
        tp.level = level;
        tp.fame = fame;

        // burn coin to upgrade NFT's level
        touch::burn(tou_supply, ctx.sender(), bal);
    }

    public entry fun set_touch_need_value(_: &AdminCap, te: &mut TouchNeedForOneLevel, val: u64) {
        te.value = val
    }

    // getter
    public entry fun get_touch_need_value(te: &TouchNeedForOneLevel): u64 {
        te.value
    }

    public entry fun get_fame(tp: &TouchProfile): String {
        tp.fame
    }

    public entry fun get_personality(tp: &TouchProfile): String {
        tp.personality
    }

    public entry fun get_level(tp: &TouchProfile): u8 {
        tp.level
    }

    public entry fun get_personality_desc(tp: &TouchProfile): String {
        tp.desc
    }
}