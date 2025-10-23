module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Current one-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    wire in_n = ~in;

    // Shared intermediate signals to reduce redundancy and area
    wire A_or_B = A | B;
    wire B_or_D = B | D;
    wire A_or_C = A | C;

    // Next state logic with improved factorization and reuse
    assign next_state[0] = in_n & A_or_C;        // A
    assign next_state[1] = in  & (A_or_B | D);   // B
    assign next_state[2] = in_n & B_or_D;        // C
    assign next_state[3] = in  & C;               // D

    // Output asserted only in state D
    assign out = D;

endmodule