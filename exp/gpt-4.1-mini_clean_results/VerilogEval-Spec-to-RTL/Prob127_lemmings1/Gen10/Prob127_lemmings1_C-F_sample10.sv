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

    // Next state combinational logic using simplified boolean expressions
    // If bumped on left (bump_left=1) => walk right (state=1)
    // Else if bumped on right => walk left (state=0)
    // If bumped on both sides, toggle state
    // Otherwise hold state
    always @(*) begin
        if (bump_left & ~bump_right)
            next_state = 1'b1;
        else if (~bump_left & bump_right)
            next_state = 1'b0;
        else if (bump_left & bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Outputs directly derived from state (Moore FSM)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule