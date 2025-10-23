module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Inverted and direct input signals
    wire in_n = ~in;

    // next_state assignments using factored expressions
    assign next_state[0] = in_n & (A | C);       // Next state A: A or C when in=0
    assign next_state[1] = in   & (A | B | D);   // Next state B: A, B or D when in=1
    assign next_state[2] = in_n & (B | D);       // Next state C: B or D when in=0
    assign next_state[3] = in   & C;             // Next state D: C when in=1

    // Output: 1 only when current state is D
    assign out = D;

endmodule