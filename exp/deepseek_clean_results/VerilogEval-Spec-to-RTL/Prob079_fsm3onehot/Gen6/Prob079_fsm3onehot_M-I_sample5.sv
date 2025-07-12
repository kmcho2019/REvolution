module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Intermediate signals for common terms
    wire in_n = ~in;
    wire state_A_or_C = state[0] | state[2];
    wire state_B_or_D = state[1] | state[3];

    // Optimized next state logic
    assign next_state[0] = in_n & state_A_or_C;  // A next: A stays when in=0 or C->A when in=0
    assign next_state[1] = in & (state[0] | state_B_or_D);  // B next: A/B/D with in=1 goes to B
    assign next_state[2] = in_n & state_B_or_D;  // C next: B/D with in=0 goes to C
    assign next_state[3] = state[2] & in;  // D next: only C with in=1 goes to D

    // Output remains optimal
    assign out = state[3];

endmodule