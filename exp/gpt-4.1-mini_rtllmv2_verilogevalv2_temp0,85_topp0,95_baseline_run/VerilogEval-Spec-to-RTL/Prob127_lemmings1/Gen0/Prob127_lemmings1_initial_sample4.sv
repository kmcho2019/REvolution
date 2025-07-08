module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    typedef enum logic {
        WALK_LEFT,
        WALK_RIGHT
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WALK_LEFT: begin
                // If bumped on left or right (or both), switch direction to right
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                // If bumped on left or right (or both), switch direction to left
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs: Moore machine outputs depend only on state
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule