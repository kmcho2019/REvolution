module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right
    reg next_state;

    always @(*) begin
        if (bump_left & bump_right)
            next_state = ~state;
        else if (bump_left)
            next_state = 1'b1;
        else if (bump_right)
            next_state = 1'b0;
        else
            next_state = state;
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left
        else
            state <= next_state;
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule