module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Current state signals
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Shared intermediate signals optimized:
    // Group all states that drive next_state[1] (B) at in=1: A, B, D
    wire AB_or_D = (A | B) | D; // same as original but no extra wire needed for inner OR

    // States for next_state[0] (A) at in=0: A, C
    wire A_or_C = A | C;

    // States for next_state[2] (C) at in=0: B, D
    wire B_or_D = B | D;

    // Assign next states with factored and minimal expressions:
    assign next_state[0] = in_n & A_or_C;    // A next: in=0 & (A|C)
    assign next_state[1] = in & AB_or_D;     // B next: in=1 & (A|B|D)
    assign next_state[2] = in_n & B_or_D;    // C next: in=0 & (B|D)
    assign next_state[3] = in & C;            // D next: in=1 & C

    // Output logic (Moore): output 1 only in state D
    assign out = D;

endmodule