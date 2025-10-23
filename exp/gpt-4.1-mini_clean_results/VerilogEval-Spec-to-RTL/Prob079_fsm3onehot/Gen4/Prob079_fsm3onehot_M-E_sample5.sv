module TopModule(
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // One-hot state encoding:
    // A = state[0]
    // B = state[1]
    // C = state[2]
    // D = state[3]

    // Intermediate signals for each transition condition:
    wire A_in_0 = state[0] & ~in; // A with in=0 -> next A
    wire A_in_1 = state[0] &  in; // A with in=1 -> next B
    wire B_in_0 = state[1] & ~in; // B with in=0 -> next C
    wire B_in_1 = state[1] &  in; // B with in=1 -> next B
    wire C_in_0 = state[2] & ~in; // C with in=0 -> next A
    wire C_in_1 = state[2] &  in; // C with in=1 -> next D
    wire D_in_0 = state[3] & ~in; // D with in=0 -> next C
    wire D_in_1 = state[3] &  in; // D with in=1 -> next B

    // Derive next_state bits by summing minterms for each next state
    assign next_state[0] = A_in_0 | C_in_0;        // next A from A(0), C(0)
    assign next_state[1] = A_in_1 | B_in_1 | D_in_1; // next B from A(1), B(1), D(1)
    assign next_state[2] = B_in_0 | D_in_0;        // next C from B(0), D(0)
    assign next_state[3] = C_in_1;                  // next D from C(1)

    // Output logic: 'out' = 1 only in state D
    assign out = state[3];

endmodule