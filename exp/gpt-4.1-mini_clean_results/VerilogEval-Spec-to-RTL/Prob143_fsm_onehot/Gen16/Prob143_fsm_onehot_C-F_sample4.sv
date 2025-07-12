module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Group states transitioning to S0 on input 0, grouped hierarchically to reduce fan-in
    // Group A: S0, S1, S2
    wire ns0_from_S0_S1_S2 = (state[0] | state[1] | state[2]) & zero_in;

    // Group B: S3, S4
    wire ns0_from_S3_S4 = (state[3] | state[4]) & zero_in;

    // Group C: S7, S8, S9
    wire ns0_from_S7_S8_S9 = (state[7] | state[8] | state[9]) & zero_in;

    // Combine groups for next_state[0]
    assign next_state[0] = ns0_from_S0_S1_S2 | ns0_from_S3_S4 | ns0_from_S7_S8_S9;

    // Next state assignments for other states (one-hot encoding)
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in; // S0, S8, S9 --> S1 on input=1
    assign next_state[2] = state[1] & one_in;                         // S1 --> S2 on input=1
    assign next_state[3] = state[2] & one_in;                         // S2 --> S3 on input=1
    assign next_state[4] = state[3] & one_in;                         // S3 --> S4 on input=1
    assign next_state[5] = state[4] & one_in;                         // S4 --> S5 on input=1
    assign next_state[6] = state[5] & one_in;                         // S5 --> S6 on input=1
    assign next_state[7] = (state[6] | state[7]) & one_in;            // S6,S7 --> S7 on input=1
    assign next_state[8] = state[5] & zero_in;                        // S5 --> S8 on input=0
    assign next_state[9] = state[6] & zero_in;                        // S6 --> S9 on input=0

    // Output logic using direct explicit ORs for clarity
    // out1 is 1 when state is S8 or S9
    assign out1 = state[8] | state[9];

    // out2 is 1 when state is S7 or S9
    assign out2 = state[7] | state[9];

endmodule