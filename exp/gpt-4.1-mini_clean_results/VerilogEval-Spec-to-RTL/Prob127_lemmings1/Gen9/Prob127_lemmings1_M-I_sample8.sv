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
            state <= 1'b0;
        end else begin
            if (bump_left & bump_right)
                state <= ~state;        // both bumps -> toggle
            else if (bump_left)
                state <= 1'b1;          // bump left -> walk right
            else if (bump_right)
                state <= 1'b0;          // bump right -> walk left
            else
                state <= state;         // no bump -> hold state
        end
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule