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

    // Strongly typed enum for FSM states
    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0 = left, 1 = right
    logic direction, next_direction;

    // 5-bit fall timer saturates at 31
    logic [4:0] fall_timer, next_fall_timer;

    // fall_too_long flag stored as a register for power efficiency (avoid repeated compare)
    logic fall_too_long, next_fall_too_long;

    // Sequential logic with asynchronous posedge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state         <= WALK;
            direction     <= 1'b0;   // walk left on reset
            fall_timer    <= 5'd0;
            fall_too_long <= 1'b0;
        end else begin
            state         <= next_state;
            direction     <= next_direction;
            fall_timer    <= next_fall_timer;
            fall_too_long <= next_fall_too_long;
        end
    end

    // Next-state logic (combinational) with priority: fall > dig > bump (walking only)
    always_comb begin
        // Default assignments (hold state)
        next_state         = state;
        next_direction     = direction;
        next_fall_timer    = 5'd0;
        next_fall_too_long = 1'b0;

        case (state)
            SPLAT: begin
                // Remain splatted forever; outputs all zero
                next_state         = SPLAT;
                next_direction     = direction; // direction retained but irrelevant
                next_fall_timer    = 5'd0;
                next_fall_too_long = 1'b0;
            end

            FALL: begin
                if (ground) begin
                    // Landed: splat if fallen too long, else walk
                    if (fall_too_long) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction     = direction; // preserve direction
                end else begin
                    // Continue falling: increment saturating at 31, update fall_too_long only once
                    next_state = FALL;
                    // Saturate fall_timer at max 31
                    if (fall_timer == 5'd31)
                        next_fall_timer = 5'd31;
                    else
                        next_fall_timer = fall_timer + 1'b1;
                    // Set fall_too_long once when timer reaches 20
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                    next_direction     = direction; // preserve direction while falling
                end
            end

            WALK: begin
                if (!ground) begin
                    // Fall takes precedence
                    next_state         = FALL;
                    next_fall_timer    = 5'd1; // start counting at 1 on first fall cycle
                    next_fall_too_long = 1'b0;
                    next_direction     = direction; // preserve direction while falling
                end else if (dig) begin
                    // Start digging if on ground and walking
                    next_state         = DIG;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction     = direction;
                end else begin
                    // Handle bumps on ground walking
                    next_state         = WALK;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                    if (bump_left && bump_right) begin
                        // Both bumps: toggle direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // Bump left => walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // Bump right => walk left
                        next_direction = 1'b0;
                    end else begin
                        next_direction = direction; // no bump, keep direction
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging: fall
                    next_state         = FALL;
                    next_fall_timer    = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction     = direction; // preserve direction
                end else begin
                    // Continue digging; bumps and dig ignored during digging
                    next_state         = DIG;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                    next_direction     = direction;
                end
            end

            default: begin
                // Defensive reset state (should never occur)
                next_state         = WALK;
                next_direction     = 1'b0;
                next_fall_timer    = 5'd0;
                next_fall_too_long = 1'b0;
            end
        endcase
    end

    // Moore outputs based on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule