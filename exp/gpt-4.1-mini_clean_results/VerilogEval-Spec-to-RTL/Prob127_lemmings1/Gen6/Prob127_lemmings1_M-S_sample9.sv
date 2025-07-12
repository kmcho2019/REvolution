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
            state <= 1'b0;  // walk_left state
        else if (bump_left || bump_right)
            state <= ~state; // flip direction if bumped
    end

    assign walk_left  = ~state;
    assign walk_right = state;

endmodule