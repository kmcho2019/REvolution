module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Factor common terms to reduce gate count and toggling
    assign next_state[0] = in_n & (A | C);         // Next state A
    assign next_state[1] = in   & (A | B | D);     // Next state B
    assign next_state[2] = in_n & (B | D);         // Next state C
    assign next_state[3] = in   & C;                // Next state D

    // Output depends only on current state D (Moore machine)
    assign out = D;

endmodule