module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg direction;  // 1 = walk left, 0 = walk right

    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b1;  // walk left on reset
        else if (bump_left | bump_right)
            direction <= ~direction;  // invert direction on any bump
    end

    assign walk_left  = direction;
    assign walk_right = ~direction;

endmodule