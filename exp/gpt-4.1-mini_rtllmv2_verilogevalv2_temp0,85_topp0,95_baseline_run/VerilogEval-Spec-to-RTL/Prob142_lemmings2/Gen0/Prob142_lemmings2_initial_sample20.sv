module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Store walking direction before falling to restore after fall
    state_t walk_dir_state;

    // Asynchronous positive edge reset, synchronous state transitions
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_dir_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update walking direction state only if not falling
            if (ground && (state != FALLING))
                walk_dir_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, remember current direction
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch to walking right if bumped on either side
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch to walking left if bumped on either side
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                // Stay falling while no ground
                if (ground) begin
                    // Return to previous walking direction after fall
                    next_state = walk_dir_state;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // safe default
        endcase
    end

    // Output logic - Moore outputs depend on current state only
    always_comb begin
        walk_left  = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
        aaah       = (state == FALLING);
    end

endmodule