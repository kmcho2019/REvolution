module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Optimized next state logic
    assign next_state[0] = ~in & (state[0] | state[2]);  // A next: A stays when in=0 or C->A when in=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]);  // B next: any state with in=1 goes to B
    assign next_state[2] = ~in & (state[1] | state[3]);  // C next: B/D with in=0 goes to C
    assign next_state[3] = state[2] & in;  // D next: only C with in=1 goes to D

    // Output remains optimal
    assign out = state[3];

endmodule