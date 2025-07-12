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
        if (areset)
            state <= 1'b0; // walk_left
        else if (bump_left | bump_right)
            state <= ~state; // toggle direction
    end

    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule