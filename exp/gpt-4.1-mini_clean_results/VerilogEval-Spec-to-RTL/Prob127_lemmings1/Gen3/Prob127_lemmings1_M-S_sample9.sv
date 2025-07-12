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
        if (areset)
            state <= 1'b0;
        else if (bump_left | bump_right)
            state <= ~state;
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule