module TopModule (
    input  clk,
    input  areset,       // async positive edge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot encoded states
    typedef struct packed {
        logic walk;
        logic dig;
        logic fall;
        logic splat;
    } state_oh_t;

    state_oh_t state, next_state;

    // Direction: 0=left, 1=right
    logic direction, next_direction;

    // 6-bit fall timer (to safely count > 20)
    logic [5:0] fall_timer, next_fall_timer;

    // Async reset logic for state and direction
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state.walk  <= 1'b1;  // start in walk state
            state.dig   <= 1'b0;
            state.fall  <= 1'b0;
            state.splat <= 1'b0;
            direction   <= 1'b0;  // start walking left
            fall_timer  <= 6'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Combinational logic for next state and direction
    always_comb begin
        // Default: hold current
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        // Helper flag: has fallen too long (>20)
        logic fallen_too_long = (fall_timer > 6'd20);

        if (state.splat) begin
            // Splat state: no transitions, outputs all zero forever
            next_state = state; 
            next_direction = direction; 
            next_fall_timer = 6'd0;
        end else if (state.fall) begin
            if (ground) begin
                // Landing after fall
                if (fallen_too_long) begin
                    next_state = '{walk:0, dig:0, fall:0, splat:1};
                end else begin
                    next_state = '{walk:1, dig:0, fall:0, splat:0};
                end
                next_fall_timer = 6'd0;
                // Keep walking direction from before fall
                next_direction = direction;
            end else begin
                // Continue falling, increment timer saturating at max (63)
                next_state = state;
                next_fall_timer = (fall_timer == 6'd63) ? fall_timer : fall_timer + 6'd1;
                next_direction = direction;
            end
        end else if (state.dig) begin
            if (!ground) begin
                // Ground disappeared while digging: start falling
                next_state = '{walk:0, dig:0, fall:1, splat:0};
                next_fall_timer = 6'd1;  // start timer
                next_direction = direction; // keep direction
            end else begin
                // Continue digging; ignore bumps and dig signal while digging
                next_state = state;
                next_fall_timer = 6'd0;
                next_direction = direction;
            end
        end else if (state.walk) begin
            // Priority: fall > dig > bump

            if (!ground) begin
                // start falling
                next_state = '{walk:0, dig:0, fall:1, splat:0};
                next_fall_timer = 6'd1;
                next_direction = direction;
            end else if (dig) begin
                // start digging
                next_state = '{walk:0, dig:1, fall:0, splat:0};
                next_fall_timer = 6'd0;
                next_direction = direction;
            end else begin
                // Bump logic while walking on ground

                // Compute if bumped on either side
                logic bump_any = bump_left | bump_right;

                // If bump detected, update direction accordingly:
                // bump_left => walk right (1)
                // bump_right => walk left (0)
                // bump both => flip direction

                if (bump_left && bump_right) begin
                    // flip direction
                    next_direction = ~direction;
                end else if (bump_left) begin
                    next_direction = 1'b1; // walk right
                end else if (bump_right) begin
                    next_direction = 1'b0; // walk left
                end else begin
                    next_direction = direction; // no bump
                end

                next_state = state;
                next_fall_timer = 6'd0;
            end
        end else begin
            // Undefined state: reset to walking left
            next_state = '{walk:1, dig:0, fall:0, splat:0};
            next_direction = 1'b0;
            next_fall_timer = 6'd0;
        end
    end

    // Moore outputs
    assign walk_left  = state.walk && (direction == 1'b0);
    assign walk_right = state.walk && (direction == 1'b1);
    assign aaah       = state.fall;
    assign digging    = state.dig;

endmodule