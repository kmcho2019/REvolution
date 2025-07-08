module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t walking_state_before_fall;

    // Asynchronous reset and state register
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_state_before_fall <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update walking_state_before_fall when transitioning from walking states
            if (state != FALLING && next_state != FALLING) begin
                walking_state_before_fall <= next_state;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state; // default hold

        case (state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped on either or both sides
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Switch direction if bumped on either or both sides
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                // Remain falling until ground returns
                if (ground == 1) begin
                    // Return to walking state before falling
                    next_state = walking_state_before_fall;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Outputs (Moore machine)
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule