module TopModule (
    input  clk,
    input  areset,       // async posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding using typedef enum for clarity
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

    // Combined bump signals
    wire bump_any  = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    // Splat condition: fall time exceeds 20 cycles
    wire splat_condition = (fall_timer > 5'd20);

    // Async reset and sequential logic for state, direction, fall_timer
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state      <= WALK;
            direction  <= 1'b0;  // walk left on reset
            fall_timer <= 5'd0;
        end else begin
            state      <= next_state;
            direction  <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and outputs logic - Moore FSM style
    always_comb begin
        // Defaults: hold current values
        next_state      = state;
        next_direction  = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Once splatted, remain forever with outputs zeroed
                next_state      = SPLAT;
                next_fall_timer = 5'd0; // timer unused
                // direction unchanged (irrelevant here)
            end

            FALL: begin
                if (ground) begin
                    // Landed
                    if (splat_condition) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_direction = direction; // preserve direction
                end else begin
                    // Continue falling and saturate fall timer at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer == 5'd31) ? 5'd31 : fall_timer + 1'b1;
                    next_direction = direction;
                end
            end

            DIG: begin
                if (!ground) begin
                    // Ground lost: start falling with timer=1
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging, ignore bumps and dig inputs
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            WALK: begin
                // Priorities: fall > dig > bump direction change
                if (!ground) begin
                    // Falling starts
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction; // preserve direction
                end else if (dig) begin
                    // Start digging if on ground
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Handle bumps to toggle or set direction
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_both) begin
                        // Both bumps flip direction
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        // bumped left, walk right
                        next_direction = 1'b1;
                    end else if (bump_right) begin
                        // bumped right, walk left
                        next_direction = 1'b0;
                    end else begin
                        next_direction = direction; // no bump, preserve direction
                    end
                end
            end

            default: begin
                // Safe fallback
                next_state      = WALK;
                next_direction  = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == 1'b0);
    assign walk_right = (state == WALK) && (direction == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule