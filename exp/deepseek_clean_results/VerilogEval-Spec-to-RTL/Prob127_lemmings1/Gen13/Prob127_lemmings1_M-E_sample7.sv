module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg toggle;  // 0 = initial left, 1 = toggled to right

    always @(posedge clk or posedge areset) begin
        if (areset)
            toggle <= 0;
        else if (bump_left || bump_right)
            toggle <= ~toggle;
    end

    // Priority: right bump over left bump when both occur
    assign walk_left = (toggle ^ bump_right) & ~(bump_left & bump_right);
    assign walk_right = ~walk_left;

endmodule