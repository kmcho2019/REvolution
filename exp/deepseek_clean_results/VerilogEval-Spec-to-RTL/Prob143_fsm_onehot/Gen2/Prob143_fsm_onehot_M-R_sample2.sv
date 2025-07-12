module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Transition to S0 happens when:
    // - Any state (except S5,S6,S7) with input=0
    // - S7/S8/S9 with input=0
    wire transition_to_S0 = (~in & (state[0] | state[1] | state[2] | state[3] | 
                            state[4] | state[7] | state[8] | state[9]));

    // Transition to S1 happens when:
    // - S0/S8/S9 with input=1
    wire transition_to_S1 = (in & (state[0] | state[8] | state[9]));

    // Transition to S2 happens when S1 with input=1
    wire transition_to_S2 = (in & state[1]);

    // Transition to S3 happens when S2 with input=1
    wire transition_to_S3 = (in & state[2]);

    // Transition to S4 happens when S3 with input=1
    wire transition_to_S4 = (in & state[3]);

    // Transition to S5 happens when S4 with input=1
    wire transition_to_S5 = (in & state[4]);

    // Transition to S6 happens when S5 with input=1
    wire transition_to_S6 = (in & state[5]);

    // Transition to S7 happens when S6/S7 with input=1
    wire transition_to_S7 = (in & (state[6] | state[7]));

    // Transition to S8 happens when S5 with input=0
    wire transition_to_S8 = (~in & state[5]);

    // Transition to S9 happens when S6 with input=0
    wire transition_to_S9 = (~in & state[6]);

    // Assign next_state bits based on transition conditions
    assign next_state = {transition_to_S9, transition_to_S8, transition_to_S7,
                        transition_to_S6, transition_to_S5, transition_to_S4,
                        transition_to_S3, transition_to_S2, transition_to_S1,
                        transition_to_S0};

    // Output logic - active only in specific states
    assign out1 = |(state & 10'b1100000000);  // S8 or S9
    assign out2 = |(state & 10'b1000001000);  // S7 or S9

endmodule