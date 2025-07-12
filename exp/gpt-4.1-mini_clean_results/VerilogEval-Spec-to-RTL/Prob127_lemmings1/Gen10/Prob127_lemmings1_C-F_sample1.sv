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
            state <= 1'b0; // walk_left
        else if (bump_left || bump_right)
            state <= (bump_left && bump_right) ? ~state : (bump_left ? 1'b1 : 1'b0);
        // else retain state implicitly (no else needed since reg holds value)
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule