module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state, next_state;

    // Next state logic
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;  // switch direction if bumped on any side
        else
            next_state = state;   // hold state if no bump
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // reset to walk_left
        else
            state <= next_state;
    end

    // Outputs reflect current state (Moore)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule