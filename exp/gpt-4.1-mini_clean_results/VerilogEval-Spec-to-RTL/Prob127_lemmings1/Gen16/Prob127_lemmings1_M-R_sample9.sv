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

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // walk_left on reset
        else
            state <= next_state;
    end

    // Next state combinational logic with explicit conditional branches
    always @(*) begin
        if (bump_left && bump_right)         // Both bumps: toggle state
            next_state = ~state;
        else if (bump_left)                  // Bump left only: walk_right
            next_state = 1'b1;
        else if (bump_right)                 // Bump right only: walk_left
            next_state = 1'b0;
        else                                // No bump: hold current state
            next_state = state;
    end

    // Outputs from state (Moore machine)
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule