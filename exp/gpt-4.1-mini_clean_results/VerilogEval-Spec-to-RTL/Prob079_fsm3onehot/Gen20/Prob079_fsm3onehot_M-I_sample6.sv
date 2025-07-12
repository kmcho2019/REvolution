module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Current state bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Shared intermediate signals for OR terms with 2-input gates
    wire A_or_B = A | B;
    wire B_or_D = B | D;
    wire A_or_C = A | C;

    // Further factor next_state[1] to reduce fan-in:
    // Instead of next_state[1] = in & (A_or_B | D), use a 2-level approach:
    // temp = A_or_B; then next_state[1] = in & (temp | D);
    // This is already minimal; still split temp or D in another OR is just one OR with two inputs, optimal.

    // Next state logic with minimized OR fan-in
    assign next_state[0] = in_n & A_or_C;     // next A
    assign next_state[1] = in & (A_or_B | D); // next B
    assign next_state[2] = in_n & B_or_D;     // next C
    assign next_state[3] = in & C;             // next D

    // Output logic (Moore): only high in state D
    assign out = D;

endmodule