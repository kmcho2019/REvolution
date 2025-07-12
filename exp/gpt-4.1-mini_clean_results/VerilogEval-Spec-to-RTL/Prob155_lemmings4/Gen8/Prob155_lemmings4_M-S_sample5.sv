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

    // Define FSM states encoding mode and direction explicitly
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        DIG_LEFT   = 3'd2,
        DIG_RIGHT  = 3'd3,
        FALL_LEFT  = 3'd4,
        FALL_RIGHT = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    // Sequential logic with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    // Next state and fall_timer logic
    always_comb begin
        next_state = state;
        next_fall_timer = fall_timer;

        // Default fall_timer increment is zero unless falling
        case(state)
            FALL_LEFT, FALL_RIGHT: begin
                if (ground) begin
                    // On landing after fall
                    if (fall_timer > 5'd20) begin
                        next_state = SPLAT;
                        next_fall_timer = 5'd0;
                    end else begin
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                        next_fall_timer = 5'd0;
                    end
                end else begin
                    // Keep falling, increment timer saturates at 31 (max 5-bit)
                    next_state = state;
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 5'd1 : fall_timer;
                end
            end

            SPLAT: begin
                // Stay splatted forever
                next_state = SPLAT;
                next_fall_timer = 5'd0;
            end

            default: begin
                // All walking or digging states
                next_fall_timer = 5'd0;

                // Prioritize fall if no ground
                if (!ground) begin
                    // Transition to falling state matching current direction
                    case(state)
                        WALK_LEFT, DIG_LEFT:  next_state = FALL_LEFT;
                        WALK_RIGHT, DIG_RIGHT: next_state = FALL_RIGHT;
                        default: next_state = state; // safety
                    endcase
                    next_fall_timer = 5'd1;
                end else begin
                    // ground = 1 and not falling
                    case(state)
                        WALK_LEFT: begin
                            if (dig)
                                next_state = DIG_LEFT;
                            else if (bump_left && bump_right)
                                next_state = WALK_RIGHT;
                            else if (bump_left)
                                next_state = WALK_RIGHT;
                            else if (bump_right)
                                next_state = WALK_LEFT;
                            else
                                next_state = WALK_LEFT;
                        end
                        WALK_RIGHT: begin
                            if (dig)
                                next_state = DIG_RIGHT;
                            else if (bump_left && bump_right)
                                next_state = WALK_LEFT;
                            else if (bump_left)
                                next_state = WALK_RIGHT;
                            else if (bump_right)
                                next_state = WALK_LEFT;
                            else
                                next_state = WALK_RIGHT;
                        end
                        DIG_LEFT: begin
                            // Continue digging if ground, else fall
                            if (!ground)
                                next_state = FALL_LEFT;
                            else
                                next_state = DIG_LEFT;
                        end
                        DIG_RIGHT: begin
                            if (!ground)
                                next_state = FALL_RIGHT;
                            else
                                next_state = DIG_RIGHT;
                        end
                        default: begin
                            next_state = WALK_LEFT; // safety fallback
                        end
                    endcase
                end
            end
        endcase
    end

    // Outputs depend only on state (Moore)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule