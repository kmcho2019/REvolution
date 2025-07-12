module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    wire in_n = ~in;
    wire st0 = state[0];
    wire st1 = state[1];
    wire st2 = state[2];
    wire st3 = state[3];

    // Factor common terms
    wire a_c_zero = in_n & (st0 | st2); // next_state A when in=0
    wire b_one = in & (st0 | st1 | st3); // next_state B when in=1
    wire c_zero = in_n & (st1 | st3); // next_state C when in=0
    wire d_one = in & st2; // next_state D when in=1

    assign next_state[0] = a_c_zero;
    assign next_state[1] = b_one;
    assign next_state[2] = c_zero;
    assign next_state[3] = d_one;

    assign out = st3; // output is high only in state D

endmodule