module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Common signals for input=0 and input=1 transitions
    wire in0 = ~in;
    wire in1 = in;

    // next_state[0]: transitions to S0 on input=0 from many states
    // states: 0,1,2,3,4,7,8,9
    wire s0_to_s0   = state[0] & in0;
    wire s1_to_s0   = state[1] & in0;
    wire s2_to_s0   = state[2] & in0;
    wire s3_to_s0   = state[3] & in0;
    wire s4_to_s0   = state[4] & in0;
    wire s7_to_s0   = state[7] & in0;
    wire s8_to_s0   = state[8] & in0;
    wire s9_to_s0   = state[9] & in0;
    assign next_state[0] = s0_to_s0 | s1_to_s0 | s2_to_s0 | s3_to_s0 | s4_to_s0 | s7_to_s0 | s8_to_s0 | s9_to_s0;

    // next_state[1]: transitions to S1 on input=1 from states 0,8,9
    assign next_state[1] = (state[0] | state[8] | state[9]) & in1;

    // next_state[2]: S1 to S2 on input=1
    assign next_state[2] = state[1] & in1;

    // next_state[3]: S2 to S3 on input=1
    assign next_state[3] = state[2] & in1;

    // next_state[4]: S3 to S4 on input=1
    assign next_state[4] = state[3] & in1;

    // next_state[5]: S4 to S5 on input=1
    assign next_state[5] = state[4] & in1;

    // next_state[6]: S5 to S6 on input=1
    assign next_state[6] = state[5] & in1;

    // next_state[7]: S6 or S7 to S7 on input=1
    assign next_state[7] = (state[6] | state[7]) & in1;

    // next_state[8]: S5 to S8 on input=0
    assign next_state[8] = state[5] & in0;

    // next_state[9]: S6 to S9 on input=0
    assign next_state[9] = state[6] & in0;

    // outputs as before
    assign out1 = |(state & 10'b1100000000); // S8 or S9
    assign out2 = |(state & 10'b0100001000); // S7 or S9

endmodule