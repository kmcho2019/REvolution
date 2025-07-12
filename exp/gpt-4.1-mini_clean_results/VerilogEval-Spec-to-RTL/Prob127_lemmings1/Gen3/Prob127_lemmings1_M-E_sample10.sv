module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg direction; // 0 = walk left, 1 = walk right

    // Async reset and direction update
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0; // walk left on reset
        else if (bump_left || bump_right)
            direction <= ~direction; // toggle direction on any bump
    end

    assign walk_left  = ~direction;
    assign walk_right = direction;

endmodule