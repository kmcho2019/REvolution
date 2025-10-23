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

    // State encoding as typedef enum for clarity
    typedef enum logic [1:0] {
        WALK  = 2'b00,
        DIG   = 2'b01,
        FALL  = 2'b10,
        SPLAT = 2'b11
    } state_t;

    state_t state, next_state;

    // Direction: 0 = left, 1 = right
    logic direction, next_direction;

    // 5-bit fall timer, saturates at 31
    logic [4:0] fall_timer, next_fall_timer;

    // Derived fall_too_long flag combinationally (no register)
    wire fall_too_long = (fall_timer > 5'd20);

    // Sequential logic with asynchronous posedge reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;   // Walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and outputs combinational logic with priority:
    // fall > dig > bump (only in WALK)
    always_comb begin
        // Defaults hold current values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splatted forever; outputs zero
                next_state      = SPLAT;
                next_direction  = direction;  // direction preserved but irrelevant
                next_fall_timer = 5'd0;
            end

            FALL: begin
                if (ground) begin
                    // Landed: splat if fallen too long, else walk
                    next_state      = fall_too_long ? SPLAT : WALK;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;  // preserve direction
                end else begin
                    // Continue falling: increment timer saturating at 31
                    next_state = FALL;
                    next_direction = direction;  // preserve direction
                    if (fall_timer == 5'd31)
                        next_fall_timer = 5'd31;
                    else
                        next_fall_timer = fall_timer + 1'b1;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging: start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;  // preserve direction
                end else begin
                    // Continue digging; ignore bumps and dig signals while digging
                    next_state      = DIG;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;
                end
            end

            WALK: begin
                // Priority: fall > dig > bump
                if (!ground) begin
                    // Start falling
                    next_state      = FALL;
                    next_fall_timer = 5'd1;
                    next_direction  = direction;  // preserve direction
                end else if (dig) begin
                    // Start digging on ground
                    next_state      = DIG;
                    next_fall_timer = 5'd0;
                    next_direction  = direction;
                end else begin
                    // Handle bumps on ground while walking
                    next_state      = WALK;
                    next_fall_timer = 5'd0;

                    if (bump_left && bump_right)
                        next_direction = ~direction;  // both bumps toggle direction
                    else if (bump_left)
                        next_direction = 1'b1;        // bumped left => walk right
                    else if (bump_right)
                        next_direction = 1'b0;        // bumped right => walk left
                    else
                        next_direction = direction;   // no bumps, keep direction
                end
            end

            default: begin
                // Defensive: reset to WALK left
                next_state      = WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs from current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule