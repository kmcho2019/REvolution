module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // next_state bits correspond to A, B, C, D
    // State encoding: A=0001, B=0010, C=0100, D=1000

    // next_state[0] = A
    // From table:
    // From A: next A if in=0
    // From C: next A if in=0
    // So next_state[A] = (state[A] & ~in) | (state[C] & ~in)
    wire A = (state[0] & ~in) | (state[2] & ~in);

    // next_state[1] = B
    // From A: next B if in=1
    // From B: next B if in=1
    // From D: next B if in=1
    wire B = (state[0] & in) | (state[1] & in) | (state[3] & in);

    // next_state[2] = C
    // From B: next C if in=0
    // From D: next C if in=0
    wire C = (state[1] & ~in) | (state[3] & ~in);

    // next_state[3] = D
    // From C: next D if in=1
    wire D = state[2] & in;

    assign next_state = {D, C, B, A};

    // output is 1 only when state is D
    assign out = state[3];

endmodule