module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Simplified next state logic using conditional operator
    // If bumps differ: next_state = bump_left (1 if bump_left, 0 if bump_right)
    // If bumps same (both or neither):
    //    If both: toggle state
    //    Else hold state
    always @(*) begin
        if (bump_left ^ bump_right)
            next_state = bump_left;            // left bump -> right walk (1), right bump -> left walk (0)
        else if (bump_left & bump_right)
            next_state = ~state;               // both bumps toggle
        else
            next_state = state;                // no bump, hold
    end

    // Outputs derived directly from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule