/// Module: touch
module touch_assets::touch {
    use sui::url;
    use sui::coin::{Self, Coin};
    use sui::balance::{Supply, Balance};
    use sui::event;
    use touch_assets::admin::AdminCap;
    use touch_assets::airdrop::Airdrop;
    use touch_assets::top_n::TopN;

    // Error
    const ENotEligible: u64 = 0;

    // Event
    public struct TouchMinted has copy, drop {
        addr: address,
        value: u64,
    }
    public struct TouchBurned has copy, drop {
        addr: address,
        value: u64,
    }

    // OTW
    public struct TOUCH has drop {}

    // Touch assets: coin
    public struct TouchSupply has key {
        id: UID,
        supply: Supply<TOUCH>
    } 

    fun init(otw: TOUCH, ctx: &mut TxContext) {
        // create fungible token
        let url = url::new_unsafe_from_bytes(
            b"https://ipfs.io/ipfs/bafybeig7cm6xn2p3wy6yw4do4o7edg5ikm77yyc3jr3tnpddonsxfnkxki/touch.png");
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            9,
            b"TOU",
            b"Touch",
            b"Collect Touch to upgrade NFT level to get more rights",
            option::some(url),
            ctx,
        );

        // make metadata immutable
        transfer::public_freeze_object(metadata);
        // wrap supply in TouchSupply and share
        let supply = coin::treasury_into_supply(treasury_cap);
        let token_point = TouchSupply {
            id: object::new(ctx),
            supply
        };
        transfer::share_object(token_point);
    }

    public fun mint(
        tou_supply: &mut TouchSupply, 
        amount: u64, 
        ctx: &mut TxContext
    ): Coin<TOUCH> {
        // let touch_balance = balance::increase_supply(&mut tou_supply.supply, amount);
        let touch_balance = tou_supply.supply.increase_supply(amount);
        coin::from_balance(touch_balance, ctx)
    }

    entry fun claim_airdrop(
        airdrop: &mut Airdrop, 
        tou_supply: &mut TouchSupply, 
        ctx: &mut TxContext
    ) {
        let sender = ctx.sender();
        assert!(airdrop.contains(sender), ENotEligible);

        // remove sender account and get the award
        let amount = airdrop.remove(sender);
        let tou_coin = mint(tou_supply, amount, ctx);
        transfer::public_transfer(tou_coin, sender);
        event::emit(TouchMinted { addr: sender, value: amount });
    } 

    entry fun claim_topn(
        top_n: &mut TopN, 
        tou_supply: &mut TouchSupply, 
        ctx: &mut TxContext
    ) {
        let sender = ctx.sender();
        assert!(top_n.contains(sender), ENotEligible);

        // remove sender account and get the award
        let (_, amount) = top_n.remove(sender);
        let tou_coin = mint(tou_supply, amount, ctx);
        transfer::public_transfer(tou_coin, sender);
        event::emit(TouchMinted { addr: sender, value: amount });
    } 

    entry fun burn_from_admin(
        _: &AdminCap, 
        tou_supply: &mut TouchSupply, 
        tou: Coin<TOUCH>,
        ctx: &TxContext
    ) {
        let bal = coin::into_balance(tou);
        burn(tou_supply, ctx.sender(), bal);
    }

    // For upgrading NFT's level
    public(package) fun burn(tou_supply: &mut TouchSupply, addr: address, bal: Balance<TOUCH>) {
        let amount = tou_supply.supply.decrease_supply(bal);
        event::emit(TouchBurned { addr, value: amount });
    }
}
