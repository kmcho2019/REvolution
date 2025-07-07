module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5,
        SPLAT      = 3'd6
    } state_t;

    state_t state, next_state;

    // Fall counter: counts how many cycles in FALL states
    reg [4:0] fall_count; // 5 bits to count up to >20

    // Determine if bumped (either side)
    wire bumped = bump_left | bump_right;

    // Sequential logic: state and fall_count update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            // Update fall_count
            if ( (state == FALL_LEFT) || (state == FALL_RIGHT) ) begin
                if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
                    // Continue falling: increment counter
                    fall_count <= fall_count + 5'd1;
                end else begin
                    // Leaving fall state: reset counter
                    fall_count <= 5'd0;
                end
            end else begin
                // Not in fall state: reset counter
                fall_count <= 5'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Fall left
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    // Start digging left
                    next_state = DIG_LEFT;
                end else if (bumped) begin
                    // Switch direction to right
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    // Fall right
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    // Start digging right
                    next_state = DIG_RIGHT;
                end else if (bumped) begin
                    // Switch direction to left
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                if (ground) begin
                    // Hit ground after falling
                    if (fall_count > 5'd20) begin
                        // Splatter
                        next_state = SPLAT;
                    end else begin
                        // Resume walking left
                        next_state = WALK_LEFT;
                    end
                end else begin
                    // Continue falling left
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (!ground) begin
                    // No ground, start falling left
                    next_state = FALL_LEFT;
                end else begin
                    // Continue digging left
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                if (!ground) begin
                    // No ground, start falling right
                    next_state = FALL_RIGHT;
                end else begin
                    // Continue digging right
                    next_state = DIG_RIGHT;
                end
            end

            SPLAT: begin
                // Remain splatted forever
                next_state = SPLAT;
            end

            default: begin
                // Should not happen, reset to WALK_LEFT
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        // Default outputs
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1'b1;
            end
            DIG_LEFT: begin
                walk_left = 1'b1;
                digging = 1'b1;
            end
            DIG_RIGHT: begin
                walk_right = 1'b1;
                digging = 1'b1;
            end
            SPLAT: begin
                // all outputs zero
            end
        endcase
    end

endmodule