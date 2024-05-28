module touch_assets::top_n {
    use sui::vec_map::{Self, VecMap};
    use touch_assets::admin::AdminCap;

    // Error
    const ELengthNotMatched: u64 = 0;

    // For collecting top n moments' accounts
    public struct TopN has key {
        id: UID,
        awards: VecMap<address, u64>,
    }

    fun init(ctx: &mut TxContext) {
        let topn_obj = TopN {
            id: object::new(ctx),
            awards: vec_map::empty(),
        };
        transfer::share_object(topn_obj);
    }

    entry fun update_topn(
        _: &AdminCap, 
        top_n: &mut TopN, 
        addrs: vector<address>, 
        amounts: vector<u64>
    ) {
        let (len, mut i) = (addrs.length(), 0u64);
        assert!(len == amounts.length(), ELengthNotMatched);

        while (i < len) {
            let (mut amount, addr) = (amounts[i], addrs[i]);

            // accumulate the award if award not been claimed
            if (top_n.contains(addr)) {
                let (_, award) = top_n.remove(addr);
                amount = amount + award
            };

            // vec_map::insert(top_n.awards, addr, amount)
            top_n.awards.insert(addr, amount);
            i = i + 1;
        }
    }

    public entry fun contains(top_n: &TopN, user: address): bool {
        top_n.awards.contains(&user)
    }

    public(package) fun remove(top_n: &mut TopN, user: address): (address, u64) {
        top_n.awards.remove(&user)
    }
}