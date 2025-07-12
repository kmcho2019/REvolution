module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Outputs depend on current state
    localparam [9:0] OUT1_MASK = 10'b1100000000; // S8, S9
    localparam [9:0] OUT2_MASK = (1 << 7) | (1 << 9); // S7, S9

    // Declare wires for each next state bit
    wire nS0, nS1, nS2, nS3, nS4, nS5, nS6, nS7, nS8, nS9;

    // Next state assignments: for each next_state bit,
    // OR of all transitions from active states that lead to it,
    // selected by input 'in'.

    // S0 transitions (next_state[0]):
    // from S0 on 0, S1 on 0, S2 on 0, S3 on 0, S4 on 0, S7 on 0, S8 on 0, S9 on 0
    // from S7 on 0 also to S0
    assign nS0 =
          (state[0] & ~in)
        | (state[1] & ~in)
        | (state[2] & ~in)
        | (state[3] & ~in)
        | (state[4] & ~in)
        | (state[7] & ~in)
        | (state[8] & ~in)
        | (state[9] & ~in);

    // S1 transitions (next_state[1]):
    // from S0 on 1, S8 on 1, S9 on 1
    assign nS1 =
          (state[0] & in)
        | (state[8] & in)
        | (state[9] & in);

    // S2 transitions (next_state[2]):
    // from S1 on 1
    assign nS2 =
        state[1] & in;

    // S3 transitions (next_state[3]):
    // from S2 on 1
    assign nS3 =
        state[2] & in;

    // S4 transitions (next_state[4]):
    // from S3 on 1
    assign nS4 =
        state[3] & in;

    // S5 transitions (next_state[5]):
    // from S4 on 1
    assign nS5 =
        state[4] & in;

    // S6 transitions (next_state[6]):
    // from S5 on 1
    assign nS6 =
        state[5] & in;

    // S7 transitions (next_state[7]):
    // from S6 on 1, from S7 on 1
    assign nS7 =
          (state[6] & in)
        | (state[7] & in);

    // S8 transitions (next_state[8]):
    // from S5 on 0
    assign nS8 =
        state[5] & ~in;

    // S9 transitions (next_state[9]):
    // from S6 on 0
    assign nS9 =
        state[6] & ~in;

    // Combine all next_state bits
    assign next_state = {nS9,nS8,nS7,nS6,nS5,nS4,nS3,nS2,nS1,nS0};

    // Output signals depend on current state bits
    assign out1 = |(state & OUT1_MASK);
    assign out2 = |(state & OUT2_MASK);

endmodule