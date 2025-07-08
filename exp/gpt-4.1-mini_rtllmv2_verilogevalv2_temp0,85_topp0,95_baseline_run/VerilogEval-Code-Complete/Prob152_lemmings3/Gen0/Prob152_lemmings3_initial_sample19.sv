module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101
    } state_t;

    state_t state, next_state;

    // Helper signals to identify walking direction or mode
    wire walking = (state == WALK_LEFT) || (state == WALK_RIGHT);
    wire falling = (state == FALL_LEFT) || (state == FALL_RIGHT);
    wire digging_st = (state == DIG_LEFT) || (state == DIG_RIGHT);

    // Extract direction from state for FALL and DIG states
    wire dir_left = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
    wire dir_right = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);

    // Asynchronous positive edge reset state register
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;

        // Priority logic as per problem statement

        // 1. FALL has highest priority
        if (!ground) begin
            // Enter falling if not already falling
            // Only transition if not already falling
            if (!falling)
                next_state = dir_left ? FALL_LEFT : FALL_RIGHT;
            // else remain falling
        end else begin
            // On ground
            if (falling) begin
                // Ground reappeared, return to walking same direction
                next_state = dir_left ? WALK_LEFT : WALK_RIGHT;
            end else if (digging_st) begin
                // DIGGING and ground lost => FALLING
                // If ground is 0 here, handled above, so here ground=1 means keep digging
                // But problem states if ground=0 while digging => fall
                // Already covered above
                next_state = DIG_LEFT; // default next state, keep digging
                if (!ground)
                    next_state = dir_left ? FALL_LEFT : FALL_RIGHT;
                else
                    next_state = state;
            end else begin
                // walking and on ground
                if (dig && walking) begin
                    // Start digging
                    next_state = dir_left ? DIG_LEFT : DIG_RIGHT;
                end else if (bump_left || bump_right) begin
                    // Switch directions if walking and bumped
                    // Bumped both sides also switches
                    // Bumping during dig or fall ignored
                    // Already confirmed walking here
                    if (dir_left)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end else begin
                    // no change
                    next_state = state;
                end
            end
        end
    end

    // Outputs from state (Moore machine)
    assign walk_left  = (state == WALK_LEFT) || (state == FALL_LEFT) || (state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT) || (state == FALL_RIGHT) || (state == DIG_RIGHT);
    assign aaah       = falling;
    assign digging    = digging_st;

endmodule