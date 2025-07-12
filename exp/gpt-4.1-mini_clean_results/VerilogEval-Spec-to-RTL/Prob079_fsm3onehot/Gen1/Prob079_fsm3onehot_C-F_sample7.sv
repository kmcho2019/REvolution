module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State encoding (one-hot):
    // A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    // next_state bits determined by inspecting transitions:
    // next_state[A] = from A(in=0) or C(in=0)
    assign next_state[0] = (state[0] & ~in) | (state[2] & ~in);

    // next_state[B] = from A(in=1), B(in=1), or D(in=1)
    // factor out 'in' for minor optimization
    assign next_state[1] = in & (state[0] | state[1] | state[3]);

    // next_state[C] = from B(in=0) or D(in=0)
    assign next_state[2] = (state[1] | state[3]) & ~in;

    // next_state[D] = from C(in=1)
    assign next_state[3] = state[2] & in;

    // Moore output: 1 only in state D
    assign out = state[3];

endmodule