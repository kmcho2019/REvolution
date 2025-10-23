module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Shared intermediate terms
    wire stay_in_A_or_C = (state[0] | state[2]) & ~in;
    wire move_to_B = in & (state[0] | state[1] | state[3]);
    wire move_to_C = ~in & (state[1] | state[3]);

    // State transition logic using shared terms
    assign next_state[0] = stay_in_A_or_C & ~state[2];  // Only from A (state[0])
    assign next_state[1] = move_to_B;
    assign next_state[2] = move_to_C;
    assign next_state[3] = in & state[2];  // Only from C when in=1

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule