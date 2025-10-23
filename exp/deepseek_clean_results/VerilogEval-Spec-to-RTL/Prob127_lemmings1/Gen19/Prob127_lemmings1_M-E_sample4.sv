module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 0 = left, 1 = right

    // Toggle direction on any bump (XOR operation)
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 0;
        else if (bump_left || bump_right)
            direction <= ~direction;
    end

    // Output assignments
    assign walk_left = ~direction;
    assign walk_right = direction;

endmodule