module TopModule(
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
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'd0,
        WALK_RIGHT = 2'd1,
        FALL_LEFT  = 2'd2,
        FALL_RIGHT = 2'd3
    } state_t;

    state_t state, next_state;
    logic digging_reg, next_digging;

    always @(*) begin
        // Defaults: no change
        next_state = state;
        next_digging = digging_reg;

        case (state)
            WALK_LEFT, WALK_RIGHT: begin
                // Priority 1: fall if ground lost
                if (!ground) begin
                    next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                    next_digging = 1'b0; // stop digging on fall
                end
                // Priority 3: start digging if dig input set and on ground and not digging
                else if (!digging_reg && dig) begin
                    next_state = state; // continue walking state
                    next_digging = 1'b1;
                end
                // Priority 6: if bumped and not digging
                else if (!digging_reg && (bump_left || bump_right)) begin
                    // Both bumps flip direction
                    if (bump_left && bump_right) begin
                        next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end
                    // Only bump_left: go right
                    else if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end
                    // Only bump_right: go left
                    else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end
                    next_digging = 1'b0;
                end
                // Priority 7: else stay same state, digging unchanged
                else begin
                    next_state = state;
                    next_digging = digging_reg;
                end
            end

            FALL_LEFT, FALL_RIGHT: begin
                // Priority 2: ground reappears, stop falling, walk same direction no digging
                if (ground) begin
                    next_state = (state == FALL_LEFT) ? WALK_LEFT : WALK_RIGHT;
                    next_digging = 1'b0;
                end else begin
                    // Continue falling
                    next_state = state;
                    next_digging = 1'b0; // digging off while falling
                end
            end

            default: begin
                next_state = WALK_LEFT;
                next_digging = 1'b0;
            end
        endcase

        // Priority 4 and 5: digging state when digging_reg is true and on ground
        // Covered in WALK states above by digging_reg.
        // Handle digging continue or ground lost while digging:
        if (digging_reg) begin
            if (!ground) begin
                // lose ground while digging => fall in current direction and stop digging
                next_state = (state == WALK_LEFT) ? FALL_LEFT : FALL_RIGHT;
                next_digging = 1'b0;
            end else begin
                // continue digging on ground
                next_state = state;
                next_digging = 1'b1;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_reg <= 1'b0;
        end else begin
            state <= next_state;
            digging_reg <= next_digging;
        end
    end

    // Outputs:
    assign walk_left  = (state == WALK_LEFT)  && !digging_reg;
    assign walk_right = (state == WALK_RIGHT) && !digging_reg;
    assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging    = digging_reg;

endmodule