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

    // Next state combinational logic
    // Toggle state if any bump input is active, else hold state
    always @(*) begin
        if (bump_left | bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore outputs directly assigned from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule