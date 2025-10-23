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
            next_state = ~state;             // both bumps: toggle state
        else if (bump_left)
            next_state = 1'b1;               // bump left only: walk right
        else if (bump_right)
            next_state = 1'b0;               // bump right only: walk left
        else
            next_state = state;              // no bumps: hold state
    end

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;                   // reset to walk_left
        else
            state <= next_state;
    end

    // Moore outputs based on registered state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule