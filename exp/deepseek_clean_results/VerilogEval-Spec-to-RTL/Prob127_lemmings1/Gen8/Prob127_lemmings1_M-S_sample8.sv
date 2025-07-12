module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 0;
        else if (state)  // if in right state
            state <= bump_right ? 0 : 1;
        else             // if in left state
            state <= bump_left ? 1 : 0;
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule