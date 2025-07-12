module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;
    reg next_state;

    // Combinational logic for next state
    always @(*) begin
        if (bump_left & bump_right)
            next_state = ~state;          // Toggle state if both bumps
        else if (bump_left)
            next_state = 1'b1;            // Walk right if bumped left
        else if (bump_right)
            next_state = 1'b0;            // Walk left if bumped right
        else
            next_state = state;           // Hold state if no bumps
    end

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;                // Reset to walk_left
        else
            state <= next_state;
    end

    // Outputs directly derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule