module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state ^ (bump_left | bump_right);
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule