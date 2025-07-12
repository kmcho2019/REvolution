module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding: A=0001, B=0010, C=0100, D=1000

    // next_state[0] = A next state bit
    // next_state[1] = B next state bit
    // next_state[2] = C next state bit
    // next_state[3] = D next state bit

    // From state transition table:
    // A: in=0 -> A, in=1 -> B
    // B: in=0 -> C, in=1 -> B
    // C: in=0 -> A, in=1 -> D
    // D: in=0 -> C, in=1 -> B

    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // A from A(in=0) or C(in=0)
    assign next_state[1] = (state[0] &  in) | (state[1] &  in) | (state[3] &  in); // B from A(in=1), B(in=1), D(in=1)
    assign next_state[2] = (state[1] & ~in) | (state[3] & ~in); // C from B(in=0), D(in=0)
    assign next_state[3] = (state[2] &  in); // D from C(in=1)

    // Output is 1 only in state D (state[3])
    assign out = state[3];

endmodule