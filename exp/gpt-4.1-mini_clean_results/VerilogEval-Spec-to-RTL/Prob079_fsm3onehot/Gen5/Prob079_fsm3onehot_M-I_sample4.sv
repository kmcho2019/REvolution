module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for convenience
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic with reduced gate fan-in
    wire a0 = A | C;       // For next_state[0]
    wire a1 = A | B;       // Partial for next_state[1]
    wire a2 = B | D;       // For next_state[2]
    wire a3 = a1 | D;      // Complete for next_state[1]

    assign next_state[0] = a0 & ~in;        // Next state A when in=0 and state is A or C
    assign next_state[1] = in & a3;         // Next state B when in=1 and state is A, B, or D
    assign next_state[2] = a2 & ~in;        // Next state C when in=0 and state is B or D
    assign next_state[3] = C & in;          // Next state D when in=1 and state is C

    // Output is 1 only in state D
    assign out = D;

endmodule