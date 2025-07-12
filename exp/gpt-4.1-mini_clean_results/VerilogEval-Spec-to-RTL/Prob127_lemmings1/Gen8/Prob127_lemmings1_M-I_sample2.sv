module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state;
    wire next_state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // walk_left on reset
        else
            state <= next_state;
    end

    // Next state combinational logic using minimal Boolean expressions
    // Logic derived from:
    // if bump_left => next_state = 1 (walk_right)
    // else if bump_right => next_state = 0 (walk_left)
    // else if both bump_left & bump_right => toggle (state ^ 1)
    // else hold state
    //
    // Simplified to:
    // next_state = bump_left | (state & ~bump_right)
    // This matches all cases:
    // bump_left=1 => next_state=1
    // bump_right=1 & bump_left=0 => next_state=state & 0 =0 => walk_left
    // bump_left=1 & bump_right=1 => next_state=1 (walk_right)
    // no bump => next_state= state & 1 = state

    assign next_state = bump_left | (state & ~bump_right);

    // Moore outputs directly assigned from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule