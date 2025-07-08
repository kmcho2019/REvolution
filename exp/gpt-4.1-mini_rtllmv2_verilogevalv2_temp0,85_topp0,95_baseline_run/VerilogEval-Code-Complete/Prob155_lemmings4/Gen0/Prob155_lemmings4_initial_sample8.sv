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
        WALK_LEFT   = 3'd0,
        WALK_RIGHT  = 3'd1,
        DIG_LEFT    = 3'd2,
        DIG_RIGHT   = 3'd3,
        FALL_LEFT   = 3'd4,
        FALL_RIGHT  = 3'd5,
        SPLATTERED  = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall duration counter
    // Counts how many cycles the Lemming has been falling
    reg [4:0] fall_counter; // 5 bits to count up to at least 20

    // State register with asynchronous active-high reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            // Increment fall counter only when falling, else reset
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 5'd1;
            end else begin
                fall_counter <= 5'd0;
            end
        end
    end

    // Next state logic (Moore FSM)
    always_comb begin
        // Default next_state is current state
        next_state = state;

        // Handle SPLATTERED: once splattered, remain splattered
        if (state == SPLATTERED) begin
            next_state = SPLATTERED;
        end else begin
            // Falling states
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (ground) begin
                    // Lemming hits ground
                    if (fall_counter > 5'd20) begin
                        // Splatter if fallen too long
                        next_state = SPLATTERED;
                    end else begin
                        // Resume walking in same direction
                        next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    // Continue falling
                    next_state = state;
                end
            end else begin
                // Not falling

                // Check ground disappearance triggers falling immediately
                if (!ground) begin
                    // Start falling in current walking/digging direction
                    case (state)
                        WALK_LEFT: next_state = FALL_LEFT;
                        WALK_RIGHT: next_state = FALL_RIGHT;
                        DIG_LEFT: next_state = FALL_LEFT;
                        DIG_RIGHT: next_state = FALL_RIGHT;
                        default: next_state = state; // Should not happen
                    endcase
                end else begin
                    // On ground

                    // If currently walking and dig=1, start digging
                    if ((state == WALK_LEFT || state == WALK_RIGHT) && dig) begin
                        next_state = (state == WALK_LEFT) ? DIG_LEFT : DIG_RIGHT;
                    end else if (state == DIG_LEFT || state == DIG_RIGHT) begin
                        // Continue digging if still on ground
                        if (ground) begin
                            // Check if ground disappears: handled above (fall)
                            next_state = state; // Continue digging
                        end else begin
                            // If no ground, fall (handled above)
                            // But since above already tests !ground => fall, no need here
                        end
                    end else if (state == WALK_LEFT || state == WALK_RIGHT) begin
                        // Walking and on ground and no dig or can't dig

                        // Check bumps to switch directions
                        if (bump_left || bump_right) begin
                            // Switch directions regardless of which bump(s) triggered
                            next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                        end else begin
                            next_state = state;
                        end
                    end else begin
                        // For other states on ground (should be none)
                        next_state = state;
                    end
                end
            end
        end
    end

    // Outputs depend only on state (Moore machine)
    assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
    assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule