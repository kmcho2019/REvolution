module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    // Intermediate signals for transitions from each state
    wire from_A0 = state[0] & ~in; // A -> A when in=0
    wire from_A1 = state[0] & in;  // A -> B when in=1

    wire from_B0 = state[1] & ~in; // B -> C when in=0
    wire from_B1 = state[1] & in;  // B -> B when in=1

    wire from_C0 = state[2] & ~in; // C -> A when in=0
    wire from_C1 = state[2] & in;  // C -> D when in=1

    wire from_D0 = state[3] & ~in; // D -> C when in=0
    wire from_D1 = state[3] & in;  // D -> B when in=1

    // Construct next state bits by combining sources
    assign next_state[0] = from_A0 | from_C0;        // A
    assign next_state[1] = from_A1 | from_B1 | from_D1; // B
    assign next_state[2] = from_B0 | from_D0;        // C
    assign next_state[3] = from_C1;                   // D

    // Output is high only in state D
    assign out = state[3];

endmodule