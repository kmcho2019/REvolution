module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // Next state logic simplified using if-else
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;  // toggle state if bumped on any side
        else
            next_state = state;   // otherwise hold state
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Outputs directly from state bits (Moore)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule