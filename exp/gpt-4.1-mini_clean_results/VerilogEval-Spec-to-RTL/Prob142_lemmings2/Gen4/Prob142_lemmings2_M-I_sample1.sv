module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // One-hot encoded states
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'b001,
        WALK_RIGHT = 3'b010,
        FALLING    = 3'b100
    } state_t;

    state_t state, next_state;

    // Direction register stores direction when falling: 0=left, 1=right
    logic dir, next_dir;

    // Asynchronous reset with synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            dir   <= 1'b0;  // direction left by default
        end else begin
            state <= next_state;
            dir   <= next_dir;
        end
    end

    // Next state and next direction combinational logic
    always_comb begin
        // Default assignments: hold current state and direction
        next_state = state;
        next_dir   = dir;

        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    // Start falling, remember current direction = left
                    next_state = FALLING;
                    next_dir = 1'b0;
                end else begin
                    // Handle bumps precisely:
                    // If bump_left = 1, switch to walk right
                    // Else if bump_right = 1, switch to walk left (stay same)
                    // If both bumps, switch to opposite direction (walk right)
                    if (bump_left && bump_right) begin
                        // Both bumps => switch direction opposite to current (WALK_LEFT => WALK_RIGHT)
                        next_state = WALK_RIGHT;
                        next_dir = 1'b1;
                    end else if (bump_left) begin
                        // bump on left => walk right
                        next_state = WALK_RIGHT;
                        next_dir = 1'b1;
                    end else if (bump_right) begin
                        // bump on right => walk left (stay same)
                        next_state = WALK_LEFT;
                        // next_dir irrelevant here
                    end else begin
                        // No bump, stay walking left
                        next_state = WALK_LEFT;
                    end
                end
            end

            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    // Start falling, remember current direction = right
                    next_state = FALLING;
                    next_dir = 1'b1;
                end else begin
                    // Handle bumps precisely:
                    // If bump_left = 1, switch to walk right (stay same)
                    // If bump_right = 1, switch to walk left
                    // If both bumps, switch direction opposite to current (WALK_RIGHT => WALK_LEFT)
                    if (bump_left && bump_right) begin
                        // Both bumps => switch opposite direction => WALK_LEFT
                        next_state = WALK_LEFT;
                        next_dir = 1'b0;
                    end else if (bump_left) begin
                        // bump on left => walk right (stay same)
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        // bump on right => walk left
                        next_state = WALK_LEFT;
                        next_dir = 1'b0;
                    end else begin
                        // No bump, stay walking right
                        next_state = WALK_RIGHT;
                    end
                end
            end

            FALLING: begin
                if (ground == 1'b1) begin
                    // Land: resume walking in stored direction
                    if (dir == 1'b0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                    // direction remains the same, no update needed
                    next_dir = dir;
                end else begin
                    // Keep falling, ignore bumps, direction unchanged
                    next_state = FALLING;
                    next_dir = dir;
                end
            end

            default: begin
                // Safety default: reset to walk left
                next_state = WALK_LEFT;
                next_dir = 1'b0;
            end
        endcase
    end

    // Outputs are directly driven by current state (Moore outputs)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule