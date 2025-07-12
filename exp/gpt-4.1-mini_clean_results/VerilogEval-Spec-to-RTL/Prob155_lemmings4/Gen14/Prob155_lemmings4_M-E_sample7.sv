module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    typedef enum logic [3:0] {
        S_WALK = 4'b0001,
        S_DIG  = 4'b0010,
        S_FALL = 4'b0100,
        S_SPLAT= 4'b1000
    } state_t;

    state_t state, next_state;
    logic direction, next_direction; // 0=left, 1=right

    // 5-bit fall timer (max 31), increments only in FALL state
    logic [4:0] fall_timer, next_fall_timer;
    logic fall_timer_en;

    // Asynchronous reset and state/direction/timer update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK;
            direction <= 1'b0;    // walk left after reset
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Fall timer enable only in FALL state
    assign fall_timer_en = (state == S_FALL);

    always_comb begin
        // Defaults
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case(state)
            S_SPLAT: begin
                // Remain in SPLAT forever until reset
                next_state = S_SPLAT;
                next_direction = direction;
                next_fall_timer = 5'd0;
            end

            S_FALL: begin
                // Increment timer only while falling, saturate at 31
                if (fall_timer_en && fall_timer != 5'd31)
                    next_fall_timer = fall_timer + 1'b1;
                else
                    next_fall_timer = fall_timer;

                if (ground) begin
                    // On hitting ground after fall
                    if (fall_timer > 5'd20) begin
                        next_state = S_SPLAT;
                        next_fall_timer = 5'd0;
                        // Direction does not matter anymore (all outputs zero)
                    end else begin
                        next_state = S_WALK;
                        next_fall_timer = 5'd0;
                        // Keep direction unchanged
                    end
                    next_direction = direction;
                end else begin
                    // Continue falling
                    next_state = S_FALL;
                    next_direction = direction;
                end
            end

            S_WALK: begin
                // Priority order: fall > dig > bump
                if (!ground) begin
                    // Start falling
                    next_state = S_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else if (dig) begin
                    // Start digging if on ground and walking
                    next_state = S_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end else begin
                    // Walking on ground: direction change on bump
                    next_state = S_WALK;
                    next_fall_timer = 5'd0;

                    // Bump logic: switch directions if bump detected
                    // If bumped on either side (or both), invert direction accordingly:
                    // bump_left => walk right (direction=1)
                    // bump_right => walk left (direction=0)
                    // bump both => invert direction
                    if (bump_left && bump_right) begin
                        next_direction = ~direction;
                    end else if (bump_left) begin
                        next_direction = 1'b1; // walk right
                    end else if (bump_right) begin
                        next_direction = 1'b0; // walk left
                    end else begin
                        next_direction = direction;
                    end
                end
            end

            S_DIG: begin
                // While digging on ground
                if (!ground) begin
                    // No ground means fall (and stop digging)
                    next_state = S_FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    // Continue digging while ground and dig finished only on falling
                    next_state = S_DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                next_state = S_WALK;
                next_direction = 1'b0;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs as pure combinational Moore outputs
    assign walk_left  = (state == S_WALK) && (direction == 1'b0);
    assign walk_right = (state == S_WALK) && (direction == 1'b1);
    assign aaah       = (state == S_FALL);
    assign digging    = (state == S_DIG);

endmodule