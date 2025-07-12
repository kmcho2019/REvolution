module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire not_in = ~in;

    // next_state[0] = A and in=0, or C and in=0 => (~in) & (A + C)
    assign next_state[0] = not_in & (A | C);

    // next_state[1] = B and in=1, D and in=1, or A and in=1
    // factor: in & (A + B + D)
    assign next_state[1] = in & (A | B | D);

    // next_state[2] = B and in=0, D and in=0 => ~in & (B + D)
    assign next_state[2] = not_in & (B | D);

    // next_state[3] = C and in=1
    assign next_state[3] = in & C;

    assign out = D;

endmodule