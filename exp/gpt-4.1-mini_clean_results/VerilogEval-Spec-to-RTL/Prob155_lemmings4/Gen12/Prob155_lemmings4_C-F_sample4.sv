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

    // Strongly typed enum for states using logic [1:0]
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

    // Flag to track if fall duration exceeded 20 cycles
    logic fall_too_long, next_fall_too_long;

    // Combined bump signals
    wire bump_any  = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

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

    // Next state combinational logic
    always_comb begin
        // Defaults to hold current values and clear timers/flags unless otherwise stated
        next_state         = state;
        next_direction     = direction;
        next_fall_timer    = 5'd0;
        next_fall_too_long = 1'b0;

        case (state)
            SPLAT: begin
                // Remain splatted indefinitely; outputs zero; no register changes needed
                next_state         = SPLAT;
                next_direction     = direction;
                next_fall_timer    = 5'd0;
                next_fall_too_long = 1'b0;
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (fall_too_long) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    // Reset fall timer and flag on landing
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                    // Direction remains unchanged when landing
                    next_direction     = direction;
                end else begin
                    // Continue falling: increment timer with saturation at 31
                    next_state      = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    // Set fall_too_long flag once fall_timer crosses 20
                    next_fall_too_long = fall_too_long | (fall_timer == 5'd20);
                    next_direction  = direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Lost ground while digging: start falling
                    next_state         = FALL;
                    next_fall_timer    = 5'd1; // start fall timer at 1 cycle
                    next_fall_too_long = 1'b0;
                    next_direction     = direction;
                end else begin
                    // Continue digging; ignore bumps and dig signal while digging
                    next_state         = DIG;
                    next_direction     = direction;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                end
            end

            WALK: begin
                // Priority: Fall > Dig > Bump direction change
                if (!ground) begin
                    // Start falling
                    next_state         = FALL;
                    next_fall_timer    = 5'd1;
                    next_fall_too_long = 1'b0;
                    next_direction     = direction;
                end else if (dig) begin
                    // Start digging on ground if requested
                    next_state         = DIG;
                    next_direction     = direction;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;
                end else begin
                    // Handle bumps while walking on ground to change direction
                    next_state         = WALK;
                    next_fall_timer    = 5'd0;
                    next_fall_too_long = 1'b0;

                    if (bump_both) begin
                        // Both bumps: toggle direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // Bump left => walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // Bump right => walk left
                        next_direction = 1'b0;
                    end else begin
                        // No bump: maintain current direction
                        next_direction = direction;
                    end
                end
            end

            default: begin
                // Defensive fallback to initial state
                next_state         = WALK;
                next_direction     = 1'b0;
                next_fall_timer    = 5'd0;
                next_fall_too_long = 1'b0;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule