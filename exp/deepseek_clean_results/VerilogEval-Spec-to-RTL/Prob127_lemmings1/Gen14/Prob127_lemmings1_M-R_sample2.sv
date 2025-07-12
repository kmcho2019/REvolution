module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    wire next_state;
    reg state;  // 0: walk_left, 1: walk_right

    // Combinational next state logic
    assign next_state = (state & ~bump_right) | (~state & bump_left);

    // DFF with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = ~state;
    assign walk_right = state;

endmodule