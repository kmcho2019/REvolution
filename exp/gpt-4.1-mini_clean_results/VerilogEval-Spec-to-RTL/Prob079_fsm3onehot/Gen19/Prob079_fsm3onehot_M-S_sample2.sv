module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A and C go to A if in=0
    assign next_state[1] = (state[0] & in)  | (state[1] & in) | (state[3] & in); // A, B, D to B if in=1
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in); // B, D to C if in=0
    assign next_state[3] = (state[2] & in);                    // C to D if in=1

    assign out = state[3]; // Output is 1 only in state D

endmodule