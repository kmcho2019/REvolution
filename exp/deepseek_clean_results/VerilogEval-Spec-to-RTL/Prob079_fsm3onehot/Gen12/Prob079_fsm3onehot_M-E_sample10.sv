module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic with priority encoding
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);  // A from A(in=0) or C(in=0)
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);  // B from A,B,D(in=1)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in);  // C from B(in=0) or D(in=0)
    assign next_state[3] = (state[2] & in);  // D from C(in=1)

    // Output is high only in state D (MSB of one-hot)
    assign out = state[3];

endmodule