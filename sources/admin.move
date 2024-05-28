// admin role module
module touch_assets::admin {

    public struct AdminCap has key, store {
        id: UID
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(AdminCap { id: object::new(ctx) }, ctx.sender());
    }
}