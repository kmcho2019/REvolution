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
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10,
        DIGGING    = 2'b11
    } state_t;

    state_t state, next_state;
    state_t prev_walk_dir; // store walking direction before falling/digging

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update prev_walk_dir when walking states
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                prev_walk_dir <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT: begin
                // Priority: falling > digging > bump
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    // Check bump conditions, switch direction if bump_left or bump_right
                    if (bump_left || bump_right) begin
                        next_state = WALK_RIGHT;
                    end
                end
            end

            WALK_RIGHT: begin
                // Priority: falling > digging > bump
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = WALK_LEFT;
                    end
                end
            end

            FALLING: begin
                // Continue falling while ground=0
                if (ground) begin
                    // Return to previous walking direction
                    next_state = prev_walk_dir;
                end
                // else remain falling
            end

            DIGGING: begin
                // While digging, bump ignored.
                // If ground disappears, transition to falling
                if (!ground) begin
                    next_state = FALLING;
                end
                // else remain digging
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore outputs depend on state only)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;

        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
            DIGGING:    digging    = 1'b1;
        endcase
    end

endmodule