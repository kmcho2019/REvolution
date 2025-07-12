module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding: state[0] = walk_left, state[1] = walk_right
    reg [1:0] state, next_state;

    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    // Next state logic expressed with bitwise operations:
    // When bumped on either side, next state is the opposite direction
    // Otherwise, hold current state
    assign next_state = (bump_any) ? {state[0], state[1]} ^ 2'b11 : state;

    // Asynchronous reset to walk_left state: state = 01
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else if (bump_any)
            state <= {state[0], state[1]} ^ 2'b11;
        else
            state <= state;
    end

    // Outputs directly follow the one-hot state bits
    assign walk_left  = state[0];
    assign walk_right = state[1];

endmodule