module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;      // 0 = walk_left, 1 = walk_right
    reg next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // Reset to walk_left
        else
            state <= next_state;
    end

    // Next state combinational logic using concise boolean logic
    always @(*) begin
        if (bump_left && bump_right)
            next_state = ~state;       // both bumps: invert direction
        else if (bump_left)
            next_state = 1'b1;         // bump_left: walk right
        else if (bump_right)
            next_state = 1'b0;         // bump_right: walk left
        else
            next_state = state;        // no bump: hold state
    end

    // Outputs: Moore FSM outputs depend only on current state
    assign walk_left  = (state == 1'b0);
    assign walk_right = (state == 1'b1);

endmodule