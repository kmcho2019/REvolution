module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    // Next state bit 0 (A)
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);
    // Next state bit 1 (B)
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
    // Next state bit 2 (C)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);
    // Next state bit 3 (D)
    assign next_state[3] = state[2] & in;

    // Output is high only when in state D
    assign out = state[3];

endmodule