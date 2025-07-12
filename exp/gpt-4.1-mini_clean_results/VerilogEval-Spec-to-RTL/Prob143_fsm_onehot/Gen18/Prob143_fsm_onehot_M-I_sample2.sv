module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Balanced OR tree for next_state[0] (states transitioning to S0 on input 0):
    wire groupA = state[0] | state[1] | state[2];     // S0, S1, S2
    wire groupB = state[3] | state[4];                // S3, S4
    wire groupC = state[7] | state[8] | state[9];     // S7, S8, S9

    wire combined_groups = groupA | groupB | groupC;
    assign next_state[0] = combined_groups & zero_in;

    // Group states that transition to same next_state on input=1 to reduce redundant AND gates
    assign next_state[1] = (state[0] | state[8] | state[9]) & one_in;
    assign next_state[2] = state[1] & one_in;
    assign next_state[3] = state[2] & one_in;
    assign next_state[4] = state[3] & one_in;
    assign next_state[5] = state[4] & one_in;
    assign next_state[6] = state[5] & one_in;
    assign next_state[7] = (state[6] | state[7]) & one_in;
    assign next_state[8] = state[5] & zero_in;
    assign next_state[9] = state[6] & zero_in;

    // Output masks for out1 and out2
    localparam [9:0] MASK_OUT1 = 10'b1100000000; // S8(8), S9(9)
    localparam [9:0] MASK_OUT2 = 10'b0100000000; // S7(7)

    wire out1_pre = |(state & MASK_OUT1);
    wire out2_pre = |(state & MASK_OUT2);

    // Assign outputs directly for potentially better synthesis optimization
    assign out1 = out1_pre;
    assign out2 = out2_pre;

endmodule