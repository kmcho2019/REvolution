module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk left, 1 = walk right
    reg state;

    // Next state logic: switch direction if bump on left or right
    wire bump_any = bump_left | bump_right;
    wire next_state = state ^ bump_any;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk left on reset
        else
            state <= next_state;
    end

    // Moore outputs based on state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule