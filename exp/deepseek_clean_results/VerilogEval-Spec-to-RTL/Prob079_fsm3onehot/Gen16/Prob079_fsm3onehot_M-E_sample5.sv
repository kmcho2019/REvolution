module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Shared intermediate terms
    wire state_0_or_2 = state[0] | state[2];
    wire state_1_or_3 = state[1] | state[3];

    // Bit-sliced state transition logic
    assign next_state[0] = ~in & state_0_or_2;    // A: active when in=0 and (A or C)
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B: active when in=1 and (A or B or D)
    assign next_state[2] = ~in & state_1_or_3;    // C: active when in=0 and (B or D)
    assign next_state[3] = in & state[2];         // D: active when in=1 and C

    // Output is simply the MSB of state (state D)
    assign out = state[3];

endmodule