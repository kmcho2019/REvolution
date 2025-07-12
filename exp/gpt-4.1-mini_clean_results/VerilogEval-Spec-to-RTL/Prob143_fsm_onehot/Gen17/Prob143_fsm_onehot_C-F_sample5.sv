module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Signals for input states for readability
    wire zero_in = ~in;
    wire one_in  =  in;

    // Hierarchical grouping for next_state[0] to reduce fan-in and improve timing
    // Group 1: States that transition to S0 on input=0: S0,S1,S2
    wire ns0_group1 = (state[0] | state[1] | state[2]) & zero_in;

    // Group 2: States that transition to S0 on input=0: S3,S4
    wire ns0_group2 = (state[3] | state[4]) & zero_in;

    // Group 3: States that transition to S0 on input=0: S7,S8,S9
    wire ns0_group3 = (state[7] | state[8] | state[9]) & zero_in;

    // Combine groups to form next_state[0]
    assign next_state[0] = ns0_group1 | ns0_group2 | ns0_group3;

    // next_state assignments for other states (flat direct assignments for clarity and performance)
    // One-hot transitions with multiple states active supported as ORs of terms
    assign next_state[1] = ((state[0] | state[8] | state[9]) & one_in);
    assign next_state[2] = (state[1] & one_in);
    assign next_state[3] = (state[2] & one_in);
    assign next_state[4] = (state[3] & one_in);
    assign next_state[5] = (state[4] & one_in);
    assign next_state[6] = (state[5] & one_in);
    assign next_state[7] = ((state[6] | state[7]) & one_in);
    assign next_state[8] = (state[5] & zero_in);
    assign next_state[9] = (state[6] & zero_in);

    // Output logic:
    // out1 = 1 when state is S8 or S9 (state[8] or state[9])
    // out2 = 1 when state is S7 or S9 (state[7] or state[9])
    // Use concise bitmasking for synthesis efficiency

    localparam [9:0] MASK_OUT1 = (1 << 8) | (1 << 9); // bits 8 and 9
    localparam [9:0] MASK_OUT2 = (1 << 7) | (1 << 9); // bits 7 and 9

    assign out1 = |(state & MASK_OUT1);
    assign out2 = |(state & MASK_OUT2);

endmodule