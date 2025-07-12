module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    // Enumerated states
    typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
    state_t state, next_state;

    // Next state logic: toggle direction if bumped on left or right (or both)
    always @(*) begin
        if (bump_left || bump_right)
            next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
        else
            next_state = state;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs derived combinationally from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule