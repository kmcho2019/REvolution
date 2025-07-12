module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding (one-hot):
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    // Factor common terms for area and power optimization
    wire in_and_AorBorD = in & (state[0] | state[1] | state[3]);
    wire not_in_and_BorD = ~in & (state[1] | state[3]);
    wire not_in_and_AorC = ~in & (state[0] | state[2]);

    // next_state[0] = A: from A(in=0) or C(in=0)
    assign next_state[0] = not_in_and_AorC;

    // next_state[1] = B: from A(in=1), B(in=1), or D(in=1)
    assign next_state[1] = in_and_AorBorD;

    // next_state[2] = C: from B(in=0) or D(in=0)
    assign next_state[2] = not_in_and_BorD;

    // next_state[3] = D: from C(in=1)
    assign next_state[3] = state[2] & in;

    // Output is 1 only in state D
    assign out = state[3];

endmodule