module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10,
        DIGGING    = 2'b11
    } state_t;

    state_t state, next_state;

    // Track walking direction for resuming after falling
    // 0 = left, 1 = right
    reg walk_dir;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir <= 1'b0; // left
        end else begin
            state <= next_state;

            // Update walk_dir only when in walking states or starting digging (walking states)
            if (next_state == WALK_LEFT)
                walk_dir <= 1'b0;
            else if (next_state == WALK_RIGHT)
                walk_dir <= 1'b1;
            else if (next_state == DIGGING) begin
                // direction stays as walk_dir
                // walk_dir unchanged here
            end
            // falling does not update walk_dir
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                // Priority: fall > dig > bump
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped on either side
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                // Priority: fall > dig > bump
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    // Switch direction
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                // While falling, bump and dig have no effect
                // If ground reappears, resume walking in direction walk_dir
                if (ground == 1) begin
                    if (walk_dir == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            DIGGING: begin
                // While digging, bumps have no effect
                // If ground disappears, transition to falling
                if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end

            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
            DIGGING: begin
                digging = 1;
                if (walk_dir == 0)
                    walk_left = 1;
                else
                    walk_right = 1;
            end
        endcase
    end

endmodule