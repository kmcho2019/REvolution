module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Next state logic as a wire combinational expression for minimal logic depth
    wire next_state = (bump_left & ~bump_right) | ((bump_left & bump_right) & ~state);

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Outputs directly derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule