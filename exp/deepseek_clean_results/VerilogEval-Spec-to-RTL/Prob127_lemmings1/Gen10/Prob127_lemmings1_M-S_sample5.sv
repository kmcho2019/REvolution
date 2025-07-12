module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else
            state <= (state & ~bump_right) | (~state & bump_left);
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule