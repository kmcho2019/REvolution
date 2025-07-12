module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: 3 bits (MSB for mode group, lower bits for direction)
    // Modes:
    // 000: WALK_LEFT
    // 001: WALK_RIGHT
    // 010: DIG_LEFT
    // 011: DIG_RIGHT
    // 100: FALL_LEFT
    // 101: FALL_RIGHT
    // 110: SPLAT (direction irrelevant)
    // 111: Unused (treat as SPLAT fallback)

    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        DIG_LEFT   = 3'b010,
        DIG_RIGHT  = 3'b011,
        FALL_LEFT  = 3'b100,
        FALL_RIGHT = 3'b101,
        SPLAT      = 3'b110;

    reg [2:0] state, next_state;

    // 5-bit fall timer for timing fall duration (max 31)
    reg [4:0] fall_timer, next_fall_timer;

    // Async reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Helper functions
    // Direction bit: LSB of state for all except SPLAT
    wire direction = state[0];

    // State category helpers
    wire is_walk = (state == WALK_LEFT) || (state == WALK_RIGHT);
    wire is_dig  = (state == DIG_LEFT)  || (state == DIG_RIGHT);
    wire is_fall = (state == FALL_LEFT) || (state == FALL_RIGHT);
    wire is_splat = (state == SPLAT);

    // Compute next state and fall_timer
    always @(*) begin
        // Default next state & timer: hold current, no timer increment
        next_state = state;
        next_fall_timer = 5'd0;

        if (is_splat) begin
            // Remain splatted forever
            next_state = SPLAT;
            next_fall_timer = 5'd0;
        end else if (is_fall) begin
            if (ground) begin
                // Landing
                // Check splatter condition: if fall_timer > 20, splat
                if (fall_timer > 5'd20)
                    next_state = SPLAT;
                else
                    // Resume walking preserving direction
                    next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;

                next_fall_timer = 5'd0;
            end else begin
                // Continue falling, increment timer saturating at 31
                if (fall_timer < 5'd31)
                    next_fall_timer = fall_timer + 1'b1;
                else
                    next_fall_timer = fall_timer;

                next_state = state; // stay falling same direction
            end
        end else if (is_walk) begin
            if (!ground) begin
                // Start falling with current direction
                next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                next_fall_timer = 5'd1; // start count at 1
            end else if (dig) begin
                // Start digging with current direction
                next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                next_fall_timer = 5'd0;
            end else if (bump_left || bump_right) begin
                // Bump switches walking direction
                // Both bumps or either bump causes direction flip or set opposite
                if (bump_left && bump_right) begin
                    // Both sides bump: invert direction
                    next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                end else if (bump_left) begin
                    // Bumped on left -> walk right
                    next_state = WALK_RIGHT;
                end else begin
                    // Bumped on right -> walk left
                    next_state = WALK_LEFT;
                end
                next_fall_timer = 5'd0;
            end else begin
                // Keep walking same direction
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end else if (is_dig) begin
            if (!ground) begin
                // No ground, start falling same direction
                next_state = (state == DIG_LEFT) ? FALL_LEFT : FALL_RIGHT;
                next_fall_timer = 5'd1;
            end else begin
                // Keep digging
                next_state = state;
                next_fall_timer = 5'd0;
            end
        end else begin
            // Undefined states go to WALK_LEFT as default safe state
            next_state = WALK_LEFT;
            next_fall_timer = 5'd0;
        end
    end

    // Outputs are Moore type: depend only on state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule