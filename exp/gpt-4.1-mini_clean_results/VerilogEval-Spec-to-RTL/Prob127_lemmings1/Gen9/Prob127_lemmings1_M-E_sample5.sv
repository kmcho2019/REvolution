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
        if (areset) begin
            walk_right_reg <= 1'b0; // start walking left
        end else begin
            if (bump_left & bump_right)
                walk_right_reg <= ~walk_right_reg;   // toggle direction if bumped both sides
            else if (bump_left)
                walk_right_reg <= 1'b1;              // bump left, walk right
            else if (bump_right)
                walk_right_reg <= 1'b0;              // bump right, walk left
            else
                walk_right_reg <= walk_right_reg;   // no bump, hold current direction
        end
    end

    assign walk_right = walk_right_reg;
    assign walk_left  = ~walk_right_reg;

endmodule