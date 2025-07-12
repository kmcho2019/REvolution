module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left_reg = 1;  // Default to walking left (reset state)
    reg walk_right_reg = 0;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_reg <= 1;
            walk_right_reg <= 0;
        end else if (walk_left_reg) begin
            walk_left_reg <= ~bump_left;
            walk_right_reg <= bump_left;
        end else begin
            walk_left_reg <= bump_right;
            walk_right_reg <= ~bump_right;
        end
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;

endmodule