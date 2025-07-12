module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // next_state assignments split by 'in' value for simpler logic
    assign next_state = (in == 1'b0) ? (
        // in=0 transitions: mostly back to S0 except for S5->S8, S6->S9, S7->S0, S8->S0, S9->S0
        // Collect all transitions leading to each state:

        // next_state[0] : S0 <-- S0,S1,S2,S3,S4,S7,S8,S9 with input 0
          state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]

        // next_state[8] : S8 <-- S5 with input 0
        | (state[5] << 8)

        // next_state[9] : S9 <-- S6 with input 0
        | (state[6] << 9)

        // other bits zero
        & 10'b1111111111  // no effect, just clarity

    ) : (
        // in=1 transitions:
        // next_state[1] : S1 <-- S0, S8, S9 with input 1
          (state[0] | state[8] | state[9]) << 1

        // next_state[2] : S2 <-- S1 with input 1
        | (state[1] << 2)

        // next_state[3] : S3 <-- S2 with input 1
        | (state[2] << 3)

        // next_state[4] : S4 <-- S3 with input 1
        | (state[3] << 4)

        // next_state[5] : S5 <-- S4 with input 1
        | (state[4] << 5)

        // next_state[6] : S6 <-- S5 with input 1
        | (state[5] << 6)

        // next_state[7] : S7 <-- S6, S7 with input 1
        | ((state[6] | state[7]) << 7)

        // next_state[0] : no transition to S0 on in=1
        );

    // To include S0 on in=0 properly, we merge the bits:
    // Wait, the above logic didn't keep the structure as 10 bits; fix that by assigning bitwise

    // Corrected next_state assignments by individual bits:

    assign next_state[0] = (in == 1'b0) && (
        state[0] || state[1] || state[2] || state[3] || state[4] || state[7] || state[8] || state[9]);

    assign next_state[1] = (in == 1'b0) ? 1'b0 : (state[0] || state[8] || state[9]);

    assign next_state[2] = (in == 1'b0) ? 1'b0 : state[1];

    assign next_state[3] = (in == 1'b0) ? 1'b0 : state[2];

    assign next_state[4] = (in == 1'b0) ? 1'b0 : state[3];

    assign next_state[5] = (in == 1'b0) ? 1'b0 : state[4];

    assign next_state[6] = (in == 1'b0) ? 1'b0 : state[5];

    assign next_state[7] = (in == 1'b0) ? 1'b0 : (state[6] || state[7]);

    assign next_state[8] = (in == 1'b0) ? state[5] : 1'b0;

    assign next_state[9] = (in == 1'b0) ? state[6] : 1'b0;

    // Outputs: directly wired to the state bits, no AND gates needed
    assign out1 = state[8] || state[9];
    assign out2 = state[7] || state[9];

endmodule