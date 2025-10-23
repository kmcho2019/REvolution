module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // walk_left on reset
        end else begin
            if (bump_left & bump_right)
                state <= ~state;            // toggle state
            else if (bump_left)
                state <= 1'b1;             // walk_right
            else if (bump_right)
                state <= 1'b0;             // walk_left
            else
                state <= state;            // hold state
        end
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule