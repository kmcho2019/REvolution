module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg walk_right_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            walk_right_reg <= 1'b0; // walk left state
        else if (bump_left | bump_right)
            walk_right_reg <= ~walk_right_reg;
    end

    assign walk_right = walk_right_reg;
    assign walk_left  = ~walk_right_reg;

endmodule