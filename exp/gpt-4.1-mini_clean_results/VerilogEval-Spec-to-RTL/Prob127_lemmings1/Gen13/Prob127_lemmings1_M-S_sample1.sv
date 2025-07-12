module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else if (bump_left | bump_right)
            state <= ~state; // toggle state on any bump
        else
            state <= state;  // hold state
    end

    // Outputs directly derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule