module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Group of current states that cause next_state = Si at in = 0 or 1
    wire [9:0] in0_transitions; // next_state bits active if in == 0
    wire [9:0] in1_transitions; // next_state bits active if in == 1

    // Define which states lead to which next states at in=0
    // Each bit corresponds to next_state bit to set when input=0 and current state is one-hot active

    // For in == 0:
    // next_state[0]: S0 --0--> S0 from states 0,1,2,3,4,7,8,9
    assign in0_transitions[0] = 
           state[0] | state[1] | state[2] | state[3] |
           state[4] | state[7] | state[8] | state[9];

    // next_state[8]: S5 --0--> S8 from state 5
    assign in0_transitions[8] = state[5];

    // next_state[9]: S6 --0--> S9 from state 6
    assign in0_transitions[9] = state[6];

    // All other next_state bits 1-7 have no transitions at in == 0
    assign in0_transitions[1] = 1'b0;
    assign in0_transitions[2] = 1'b0;
    assign in0_transitions[3] = 1'b0;
    assign in0_transitions[4] = 1'b0;
    assign in0_transitions[5] = 1'b0;
    assign in0_transitions[6] = 1'b0;
    assign in0_transitions[7] = 1'b0;

    // For in == 1:
    // next_state[1]: S0, S8, S9 --1--> S1
    assign in1_transitions[1] = state[0] | state[8] | state[9];

    // next_state[2]: S1 --1--> S2
    assign in1_transitions[2] = state[1];

    // next_state[3]: S2 --1--> S3
    assign in1_transitions[3] = state[2];

    // next_state[4]: S3 --1--> S4
    assign in1_transitions[4] = state[3];

    // next_state[5]: S4 --1--> S5
    assign in1_transitions[5] = state[4];

    // next_state[6]: S5 --1--> S6
    assign in1_transitions[6] = state[5];

    // next_state[7]: S6, S7 --1--> S7
    assign in1_transitions[7] = state[6] | state[7];

    // next_state[0], [8], [9] have no transitions at in == 1
    assign in1_transitions[0] = 1'b0;
    assign in1_transitions[8] = 1'b0;
    assign in1_transitions[9] = 1'b0;

    // Generate next_state by selecting transitions per input value
    assign next_state = in ? in1_transitions : in0_transitions;

    // Outputs from current states:
    // out1 = 1 if in S8 or S9 (state[8] or state[9])
    // out2 = 1 if in S7 or S9 (state[7] or state[9])
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule