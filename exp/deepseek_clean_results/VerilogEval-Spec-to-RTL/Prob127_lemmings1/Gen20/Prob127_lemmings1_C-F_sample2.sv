module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    wire next_state;

    // Compact transition logic using XOR
    assign next_state = state ^ (bump_left & ~state) ^ (bump_right & state);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end

    // Direct output assignments
    assign walk_left = ~state;
    assign walk_right = state;

endmodule