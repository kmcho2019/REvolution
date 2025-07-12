module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Corrected next_state[0] logic (removed S5 and S6 transitions)
    assign next_state[0] = (state[0] & ~in) |  // S0 stays on 0
                          (state[1] & ~in) |  // S1 -> S0 on 0
                          (state[2] & ~in) |  // S2 -> S0 on 0
                          (state[3] & ~in) |  // S3 -> S0 on 0
                          (state[4] & ~in) |  // S4 -> S0 on 0
                          (state[7] & ~in) |  // S7 -> S0 on 0
                          (state[8] & ~in) |  // S8 -> S0 on 0
                          (state[9] & ~in);   // S9 -> S0 on 0

    // Other next_state bits remain correct
    assign next_state[1] = (state[0] & in) | (state[8] & in) | (state[9] & in);
    assign next_state[2] = state[1] & in;
    assign next_state[3] = state[2] & in;
    assign next_state[4] = state[3] & in;
    assign next_state[5] = state[4] & in;
    assign next_state[6] = state[5] & in;
    assign next_state[7] = (state[6] & in) | (state[7] & in);
    assign next_state[8] = state[5] & ~in;
    assign next_state[9] = state[6] & ~in;

    // Simplified output logic
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];
    
endmodule