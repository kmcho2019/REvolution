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
    always @(*) begin
        case ({bump_left, bump_right})
            2'b10: next_state = 1'b1;       // bump left => walk right
            2'b01: next_state = 1'b0;       // bump right => walk left
            2'b11: next_state = ~state;     // both bumps => toggle direction
            default: next_state = state;    // no bumps => hold state
        endcase
    end

    // Moore outputs directly assigned from state to minimize logic
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule