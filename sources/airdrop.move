module touch_assets::airdrop {
    use sui::table::{Self, Table};
    use touch_assets::admin::AdminCap;

    // Error
    const ELengthNotMatched: u64 = 0;
    const ENotEmpty: u64 = 1;

    // For airdroping: early airdrop and game point converting
    public struct Airdrop has key {
        id: UID,
        addrs: vector<address>,
        awards: Table<address, u64>,
    }

    fun init(ctx: &mut TxContext) {
        let airdrop_obj = Airdrop {
            id: object::new(ctx),
            addrs: vector::empty<address>(),
            awards: table::new(ctx),
        };
        transfer::share_object(airdrop_obj);
    }

    fun add(airdrop: &mut Airdrop, addr: address, amount: u64) {
        airdrop.addrs.push_back(addr);
        airdrop.awards.add(addr, amount);
    }
    
    entry fun update_airdrop(
        _: &AdminCap, 
        airdrop: &mut Airdrop, 
        addrs: vector<address>, 
        amounts: vector<u64>,
    ) {
        let (len, mut i) = (addrs.length(), 0u64);
        assert!(len == amounts.length(), ELengthNotMatched);
        assert!(airdrop.is_empty(), ENotEmpty);

        while (i < len) {
            airdrop.add(addrs[i], amounts[i]);
            i = i + 1;
        }
    }

    entry fun clear_airdrop(
        _: &AdminCap, 
        airdrop: &mut Airdrop, 
    ) {
        let (len, mut i) = (airdrop.addrs.length(), 0u64);

        // clear awards
        if (airdrop.awards.length() > 0) {
            while (i < len) {
                let addr = airdrop.addrs[i];
                if (airdrop.contains(addr)) {
                    airdrop.remove(addr);
                };
                i = i + 1;
            };
        };
        // clear addrs
        airdrop.addrs = vector::empty<address>();
        // addrs and awards must all be empty
        assert!(airdrop.is_empty(), ENotEmpty);
    } 

    public fun is_empty(airdrop: &Airdrop): bool {
        airdrop.awards.length() == 0 && airdrop.addrs.length() == 0
    }

    public(package) fun remove(airdrop: &mut Airdrop, user: address): u64 {
        airdrop.awards.remove(user)
    }

    public entry fun contains(airdrop: &Airdrop, user: address): bool {
        airdrop.awards.contains(user)
    }
}