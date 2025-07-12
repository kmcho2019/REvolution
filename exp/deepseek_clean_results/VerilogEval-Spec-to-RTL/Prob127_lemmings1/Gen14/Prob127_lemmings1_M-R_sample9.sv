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

    // Combinational next state logic
    assign next_state = (state & ~bump_right) | (~state & bump_left);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = ~state;
    assign walk_right = state;

endmodule