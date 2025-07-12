module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;  // 0 = walk_left, 1 = walk_right

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state logic simplified:
    // If any bump (left or right) is active, switch direction.
    // Bumps both sides → toggle direction
    always @(*) begin
        if (bump_left | bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Outputs: walk_right is state, walk_left is inverse of state
    assign walk_right = state;
    assign walk_left  = ~state;

endmodule