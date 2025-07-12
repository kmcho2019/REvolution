module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;  // 0 = left, 1 = right

    // Toggle state on any bump (XOR operation)
    always @(posedge clk or posedge areset) begin
        if (areset)
            toggle <= 0;
        else if (bump_left || bump_right)
            toggle <= ~toggle;
    end

    // Output assignments
    assign walk_left = ~toggle;
    assign walk_right = toggle;

endmodule