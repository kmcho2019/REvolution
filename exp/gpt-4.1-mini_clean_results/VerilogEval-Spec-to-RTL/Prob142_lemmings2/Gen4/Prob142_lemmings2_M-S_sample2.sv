module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t fall_dir; // Remembers walking direction before falling

    // Asynchronous reset, synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            fall_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update fall_dir only when entering FALLING from walking states
            if (state != FALLING && next_state == FALLING) begin
                fall_dir <= state; // remember current walking direction
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state; // default hold
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // On bump_left switch to WALK_RIGHT
                    // On bump_right switch to WALK_LEFT (no change here)
                    // If both bumps, switch direction as per bump_left priority first:
                    // Specification says bump_left means switch right, bump_right means switch left,
                    // and if both, still switch direction, so if both bumps, switch direction anyway.
                    if (bump_left)
                        next_state = WALK_RIGHT;
                    else if (bump_right)
                        next_state = WALK_LEFT; // stays same as WALK_LEFT, so no change
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bump_left means switch right (stay WALK_RIGHT),
                    // bump_right means switch left,
                    // both bumps means switch direction anyway.
                    if (bump_right)
                        next_state = WALK_LEFT;
                    else if (bump_left)
                        next_state = WALK_RIGHT; // stays same
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground) begin
                    // Resume walking in direction before falling
                    next_state = fall_dir;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule