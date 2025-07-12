module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State encoding
    // A=4'b0001
    // B=4'b0010
    // C=4'b0100
    // D=4'b1000

    // next_state bits
    // next_state[0] = A
    // next_state[1] = B
    // next_state[2] = C
    // next_state[3] = D

    wire in_not = ~in;

    // next_state[0] = A
    // A->A (in=0), C->A (in=0)
    assign next_state[0] = (state[0] & in_not) | (state[2] & in_not);

    // next_state[1] = B
    // A->B (in=1), B->B (in=1), D->B (in=1)
    assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);

    // next_state[2] = C
    // B->C (in=0), D->C (in=0)
    assign next_state[2] = (state[1] & in_not) | (state[3] & in_not);

    // next_state[3] = D
    // C->D (in=1)
    assign next_state[3] = state[2] & in;

    // output is 1 only in state D
    assign out = state[3];

endmodule