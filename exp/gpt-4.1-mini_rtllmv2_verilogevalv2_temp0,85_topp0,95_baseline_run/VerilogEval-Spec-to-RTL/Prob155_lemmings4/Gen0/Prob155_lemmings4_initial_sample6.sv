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

    // Define states
    typedef enum logic [2:0] {
        WALK_LEFT = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT = 3'd4,
        DIG_RIGHT = 3'd5,
        SPLAT = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall counter: counts how many cycles have been falling
    // Needs to count up to >20, so 5 bits enough (0 to 31)
    logic [5:0] fall_counter, next_fall_counter;

    // Async reset and synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'd0;
        end else begin
            state <= next_state;
            fall_counter <= next_fall_counter;
        end
    end

    // Next state and fall counter logic
    always_comb begin
        // Default assignments
        next_state = state;
        next_fall_counter = fall_counter;

        // Bump detected if either bump_left or bump_right is high
        logic bumped = bump_left | bump_right;

        case(state)
            SPLAT: begin
                // Once splatted, stay splatted forever until reset
                next_state = SPLAT;
                next_fall_counter = 6'd0;
            end

            WALK_LEFT: begin
                if (ground == 0) begin
                    // Ground disappears, start falling left
                    next_state = FALL_LEFT;
                    next_fall_counter = 6'd1;
                end else if (dig && ground == 1) begin
                    // Start digging left only if on ground and not falling
                    next_state = DIG_LEFT;
                    next_fall_counter = 6'd0;
                end else if (bumped) begin
                    // Switch direction if bumped
                    next_state = WALK_RIGHT;
                    next_fall_counter = 6'd0;
                end else begin
                    next_state = WALK_LEFT;
                    next_fall_counter = 6'd0;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    // Ground disappears, start falling right
                    next_state = FALL_RIGHT;
                    next_fall_counter = 6'd1;
                end else if (dig && ground == 1) begin
                    // Start digging right only if on ground and not falling
                    next_state = DIG_RIGHT;
                    next_fall_counter = 6'd0;
                end else if (bumped) begin
                    // Switch direction if bumped
                    next_state = WALK_LEFT;
                    next_fall_counter = 6'd0;
                end else begin
                    next_state = WALK_RIGHT;
                    next_fall_counter = 6'd0;
                end
            end

            FALL_LEFT: begin
                if (ground == 0) begin
                    // Still falling left, increment fall counter
                    next_state = FALL_LEFT;
                    if (fall_counter == 6'd63) // saturation to avoid wrap
                        next_fall_counter = 6'd63;
                    else
                        next_fall_counter = fall_counter + 6'd1;
                end else begin
                    // Landed on ground after falling
                    // Check if splatter condition met
                    if (fall_counter > 6'd20) begin
                        // Splatter
                        next_state = SPLAT;
                        next_fall_counter = 6'd0;
                    end else begin
                        // Resume walking left
                        next_state = WALK_LEFT;
                        next_fall_counter = 6'd0;
                    end
                end
            end

            FALL_RIGHT: begin
                if (ground == 0) begin
                    // Still falling right, increment fall counter
                    next_state = FALL_RIGHT;
                    if (fall_counter == 6'd63)
                        next_fall_counter = 6'd63;
                    else
                        next_fall_counter = fall_counter + 6'd1;
                end else begin
                    // Landed on ground after falling
                    if (fall_counter > 6'd20) begin
                        next_state = SPLAT;
                        next_fall_counter = 6'd0;
                    end else begin
                        next_state = WALK_RIGHT;
                        next_fall_counter = 6'd0;
                    end
                end
            end

            DIG_LEFT: begin
                if (ground == 0) begin
                    // No ground while digging means start falling left
                    next_state = FALL_LEFT;
                    next_fall_counter = 6'd1;
                end else begin
                    // Continue digging left while ground present
                    next_state = DIG_LEFT;
                    next_fall_counter = 6'd0;
                end
            end

            DIG_RIGHT: begin
                if (ground == 0) begin
                    // No ground while digging means start falling right
                    next_state = FALL_RIGHT;
                    next_fall_counter = 6'd1;
                end else begin
                    // Continue digging right while ground present
                    next_state = DIG_RIGHT;
                    next_fall_counter = 6'd0;
                end
            end

            default: begin
                // Unknown state, reset to WALK_LEFT
                next_state = WALK_LEFT;
                next_fall_counter = 6'd0;
            end
        endcase
    end

    // Output logic (Moore)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule