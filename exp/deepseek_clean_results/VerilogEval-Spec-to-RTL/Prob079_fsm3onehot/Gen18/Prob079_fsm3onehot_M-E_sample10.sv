module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Parallel condition evaluation for each next state
    wire cond_A0 = state[0] & ~in;  // Stay in A when in=0
    wire cond_A1 = state[2] & ~in;  // Move to A from C when in=0
    wire cond_B0 = state[0] & in;   // Move to B from A when in=1
    wire cond_B1 = state[1] & in;   // Stay in B when in=1
    wire cond_B2 = state[3] & ~in;  // Move to B from D when in=0 (via C)
    wire cond_C0 = state[1] & ~in;  // Move to C from B when in=0
    wire cond_C1 = state[3] & ~in;  // Move to C from D when in=0
    wire cond_D0 = state[2] & in;   // Move to D from C when in=1

    // OR-reduce all conditions for each next state
    assign next_state[0] = cond_A0 | cond_A1;
    assign next_state[1] = cond_B0 | cond_B1 | cond_B2;
    assign next_state[2] = cond_C0 | cond_C1;
    assign next_state[3] = cond_D0;

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule