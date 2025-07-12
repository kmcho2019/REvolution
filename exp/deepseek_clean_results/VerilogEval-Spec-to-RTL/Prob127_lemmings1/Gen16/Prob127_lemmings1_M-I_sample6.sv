module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0: left, 1: right

    // Optimized state transition using XOR
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else if (bump_left || bump_right)
            state <= state ^ 1'b1;
    end

    // Output assignments using bitwise operations
    assign walk_left = ~state;
    assign walk_right = state;

endmodule