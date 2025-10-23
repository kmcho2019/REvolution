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

    // State encoding using enum for clarity
    typedef enum logic [1:0] {
        WALK = 2'b00,
        DIG  = 2'b01,
        FALL = 2'b10,
        SPLAT= 2'b11
    } state_t;

    // Direction encoding
    typedef enum logic {
        LEFT  = 1'b0,
        RIGHT = 1'b1
    } direction_t;

    state_t state, next_state;
    direction_t direction, next_direction;

    // Fall timer counts fall duration
    // 5-bit counter sufficient for counting >20 cycles
    logic [4:0] fall_timer, next_fall_timer;

    // Synchronous reset (areset sampled on clk)
    always_ff @(posedge clk) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and direction logic: prioritize fall > dig > bump changes
    always_comb begin
        // Default: hold current values
        next_state = state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (state)
            SPLAT: begin
                // Remain splattered forever until reset
                next_state = SPLAT;
                next_fall_timer = 5'd0; // no timer needed
                next_direction = direction;
            end

            FALL: begin
                if (ground) begin
                    // Landed: check if splatter
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK;
                    end
                    next_fall_timer = 5'd0;
                    next_direction = direction; // direction unchanged
                end else begin
                    // Still falling, increment timer with saturation at 31
                    next_state = FALL;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : fall_timer;
                    next_direction = direction;
                end
            end

            WALK: begin
                // Priority: fall if no ground
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end
                // then dig if requested and on ground
                else if (dig) begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
                // else handle bumps to update direction
                else if (bump_left || bump_right) begin
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    if (bump_left && bump_right) begin
                        next_direction = ~direction; // toggle direction
                    end else if (bump_left) begin
                        next_direction = RIGHT;
                    end else begin
                        next_direction = LEFT;
                    end
                end else begin
                    // No bump, keep walking same direction
                    next_state = WALK;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            DIG: begin
                // Fall has priority over digging if no ground
                if (!ground) begin
                    next_state = FALL;
                    next_fall_timer = 5'd1;
                    next_direction = direction;
                end else begin
                    next_state = DIG;
                    next_fall_timer = 5'd0;
                    next_direction = direction;
                end
            end

            default: begin
                // Recover from unknown state
                next_state = WALK;
                next_direction = LEFT;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Moore outputs depend only on current state and direction
    assign walk_left  = (state == WALK) && (direction == LEFT);
    assign walk_right = (state == WALK) && (direction == RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule