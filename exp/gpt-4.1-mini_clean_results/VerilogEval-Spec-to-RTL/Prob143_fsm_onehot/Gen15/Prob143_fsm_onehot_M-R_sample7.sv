module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero = ~in;
    wire one  =  in;

    // Each state's contribution to next_state on input=0 or 1

    // next_state[0] is set when any state transitions to S0 on in=0
    assign next_state[0] =
          (state[0] & zero) // S0 -> S0 on 0
        | (state[1] & zero) // S1 -> S0 on 0
        | (state[2] & zero) // S2 -> S0 on 0
        | (state[3] & zero) // S3 -> S0 on 0
        | (state[4] & zero) // S4 -> S0 on 0
        | (state[7] & zero) // S7 -> S0 on 0
        | (state[8] & zero) // S8 -> S0 on 0
        | (state[9] & zero); // S9 -> S0 on 0

    assign next_state[1] =
          (state[0] & one)  // S0 -> S1 on 1
        | (state[8] & one)  // S8 -> S1 on 1
        | (state[9] & one); // S9 -> S1 on 1

    assign next_state[2] = state[1] & one; // S1 -> S2 on 1
    assign next_state[3] = state[2] & one; // S2 -> S3 on 1
    assign next_state[4] = state[3] & one; // S3 -> S4 on 1
    assign next_state[5] = state[4] & one; // S4 -> S5 on 1

    assign next_state[6] = state[5] & one; // S5 -> S6 on 1
    assign next_state[7] =
          (state[6] & one)  // S6 -> S7 on 1
        | (state[7] & one); // S7 -> S7 on 1 (loop)

    assign next_state[8] = state[5] & zero; // S5 -> S8 on 0
    assign next_state[9] = state[6] & zero; // S6 -> S9 on 0

    // Outputs defined by state bits:
    assign out1 = |(state & 10'b1100000000); // S8 or S9 active
    assign out2 = |(state & 10'b0100001000); // S7 or S9 active

endmodule