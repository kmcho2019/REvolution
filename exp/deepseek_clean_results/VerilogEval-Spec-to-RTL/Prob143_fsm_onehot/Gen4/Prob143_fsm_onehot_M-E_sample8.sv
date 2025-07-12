module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Priority-based next state logic
    assign next_state[0] = (~in & (|state)) |  // Default transition to S0
                         (in & ~(|state[9:1])); // Stay in S0 if no other states active

    assign next_state[1] = in & (state[0] | state[8] | state[9]) & ~(|state[9:2]);
    assign next_state[2] = in & state[1] & ~(|state[9:3]);
    assign next_state[3] = in & state[2] & ~(|state[9:4]);
    assign next_state[4] = in & state[3] & ~(|state[9:5]);
    assign next_state[5] = in & state[4] & ~(|state[9:6]);
    assign next_state[6] = in & state[5] & ~(|state[9:7]);
    assign next_state[7] = in & (state[6] | state[7]) & ~(|state[9:8]);
    assign next_state[8] = ~in & state[5] & ~(|state[9:9]);
    assign next_state[9] = ~in & state[6];

    // Priority-based output logic (only highest priority state contributes)
    assign out1 = (|state[9:8]) & ~(|state[7:0]);  // Only S8 or S9 if no higher states
    assign out2 = (state[7] | state[9]) & ~(|state[8:8] & ~state[9]);  // S7 or S9, but S8 takes precedence for out1

endmodule