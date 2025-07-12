module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // walk_left
        end else if (bump_left & bump_right) begin
            state <= ~state;        // bump both, invert direction
        end else if (bump_left) begin
            state <= 1'b1;          // bump_left, walk_right
        end else if (bump_right) begin
            state <= 1'b0;          // bump_right, walk_left
        end
        // else state remains unchanged
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule