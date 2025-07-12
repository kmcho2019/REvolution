module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    wire not_in = ~in;
    wire from_A_or_C = state[0] | state[2];
    wire from_B_or_D = state[1] | state[3];

    // Optimized state transition logic
    assign next_state[0] = not_in & from_A_or_C;  // A: from A(in=0) or C(in=0)
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B: from A/B/D when in=1
    assign next_state[2] = not_in & from_B_or_D;  // C: from B(in=0) or D(in=0)
    assign next_state[3] = in & state[2];         // D: from C when in=1

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule