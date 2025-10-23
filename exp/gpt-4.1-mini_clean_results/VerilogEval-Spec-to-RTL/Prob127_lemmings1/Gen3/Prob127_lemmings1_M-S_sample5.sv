module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk left, 1 = walk right
    reg state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk left
        else if (bump_left || bump_right)
            state <= ~state; // toggle state on bump
    end

    // Moore outputs derived from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule