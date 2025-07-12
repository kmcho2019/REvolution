module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0 = walk_left, 1 = walk_right

    // Next state logic optimized using boolean expressions:
    wire toggle = bump_left & bump_right;
    wire bump_left_only = bump_left & ~bump_right;
    wire bump_right_only = ~bump_left & bump_right;

    wire next_state = (toggle) ? ~state :
                      (bump_left_only) ? 1'b1 :
                      (bump_right_only) ? 1'b0 :
                      state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule