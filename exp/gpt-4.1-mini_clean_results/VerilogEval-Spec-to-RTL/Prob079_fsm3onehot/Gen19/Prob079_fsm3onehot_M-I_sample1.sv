module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    wire a = state[0];
    wire b = state[1];
    wire c = state[2];
    wire d = state[3];

    // Factor common terms to reduce gates and levels
    // next_state[0] = A_next = A(in=0) + C(in=0) = a & ~in + c & ~in = (a + c) & ~in
    assign next_state[0] = (a | c) & ~in;

    // next_state[1] = B_next = A(in=1) + B(in=1) + D(in=1) = a & in + b & in + d & in = (a + b + d) & in
    assign next_state[1] = (a | b | d) & in;

    // next_state[2] = C_next = B(in=0) + D(in=0) = b & ~in + d & ~in = (b + d) & ~in
    assign next_state[2] = (b | d) & ~in;

    // next_state[3] = D_next = C(in=1) = c & in
    assign next_state[3] = c & in;

    // Output is 1 only in state D
    assign out = d;

endmodule