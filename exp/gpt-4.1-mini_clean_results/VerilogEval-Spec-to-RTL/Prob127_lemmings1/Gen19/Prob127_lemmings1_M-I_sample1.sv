module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state, next_state;

    // Next-state logic: switch if bumped on corresponding side
    // If bump_left=1 while walking left, switch to right (1)
    // If bump_right=1 while walking right, switch to left (0)
    // If bump on both sides simultaneously, switch directions as well
    always @(*) begin
        if (state == 0) // walking left
            next_state = bump_left ? 1'b1 : 1'b0;
        else // walking right
            next_state = bump_right ? 1'b0 : 1'b1;
    end

    // Asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else
            state <= next_state;
    end

    // Output walk_left directly from state (0 means walk_left)
    always @(*) begin
        walk_left = ~state;
    end

    // walk_right is complement of walk_left
    assign walk_right = state;

endmodule