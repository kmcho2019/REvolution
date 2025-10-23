module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg state, next_state;

    // Next-state logic: flip state if bumped on corresponding side(s)
    // If bumped on left or right (or both), switch direction
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // State register with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Outputs derived directly from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule