module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Factor out terms to minimize logic:
    // next_state[0] = ~in & (state[A] | state[C])
    // next_state[1] = in & (state[A] | state[B] | state[D])
    //   = in & (state[A] | state[B] | state[D])
    // next_state[2] = ~in & (state[B] | state[D])
    // next_state[3] = in & state[C]

    // No further factoring reduces literals here significantly.
    // Still, for clarity and minimal power, define common signals:

    wire a_c = state[0] | state[2];
    wire b_d = state[1] | state[3];
    wire a_b_d = state[0] | state[1] | state[3];

    assign next_state[0] = ~in & a_c;
    assign next_state[1] =  in & a_b_d;
    assign next_state[2] = ~in & b_d;
    assign next_state[3] =  in & state[2];

    assign out = state[3];

endmodule