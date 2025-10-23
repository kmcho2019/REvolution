module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Intermediate signals for common subexpressions
    wire in_state0 = in & state[0];
    wire in_state1 = in & state[1];
    wire in_state3 = in & state[3];
    wire nin_state1 = ~in & state[1];
    wire nin_state3 = ~in & state[3];

    // Next state logic with optimized common subexpressions
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // A stays or C->A
    assign next_state[1] = in_state0 | in_state1 | in_state3;     // A->B, B stays, D->B
    assign next_state[2] = nin_state1 | nin_state3;               // B->C, D->C
    assign next_state[3] = in & state[2];                         // C->D

    // Output logic (simply the MSB of current state)
    assign out = state[3];

endmodule