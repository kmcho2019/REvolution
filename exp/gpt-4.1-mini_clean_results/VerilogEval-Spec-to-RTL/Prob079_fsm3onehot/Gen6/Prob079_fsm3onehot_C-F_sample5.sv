module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot encoded state bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Next state logic - factored for minimal gate usage and clarity
    assign next_state[0] = in_n & (A | C);      // Next state A when in=0 and in states A or C
    assign next_state[1] = in   & (A | B | D);  // Next state B when in=1 and in states A, B, or D
    assign next_state[2] = in_n & (B | D);      // Next state C when in=0 and in states B or D
    assign next_state[3] = in   & C;            // Next state D when in=1 and in state C

    // Output logic: output is 1 only in state D (Moore machine)
    assign out = D;

endmodule