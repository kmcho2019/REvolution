module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else if (bump_left || bump_right)
            state <= ~state; // toggle direction on bump(s)
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule