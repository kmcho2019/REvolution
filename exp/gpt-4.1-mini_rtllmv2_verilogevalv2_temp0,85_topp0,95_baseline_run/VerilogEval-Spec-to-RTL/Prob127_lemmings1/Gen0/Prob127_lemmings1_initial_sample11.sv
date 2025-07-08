module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // Define states
    typedef enum logic [0:0] {
        WALK_LEFT  = 1'b0,
        WALK_RIGHT = 1'b1
    } state_t;

    state_t state, next_state;

    // Asynchronous positive edge reset, synchronous state update
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            WALK_LEFT: begin
                // If bumped on left or right, switch to walk right
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                // If bumped on left or right, switch to walk left
                if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Outputs: Moore outputs depend on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule