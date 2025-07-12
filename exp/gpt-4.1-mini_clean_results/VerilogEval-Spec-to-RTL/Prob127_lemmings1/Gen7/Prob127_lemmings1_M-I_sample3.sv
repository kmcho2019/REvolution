module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state, next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state combinational logic simplified:
    // If bump_left and bump_right are both asserted, toggle state.
    // Else if bump_left is asserted, next state is walk_right (1).
    // Else if bump_right is asserted, next state is walk_left (0).
    // Else hold current state.
    always @(*) begin
        if (bump_left & bump_right)
            next_state = ~state;
        else if (bump_left)
            next_state = 1'b1;
        else if (bump_right)
            next_state = 1'b0;
        else
            next_state = state;
    end

    // Moore outputs directly assigned from state for minimal logic
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule