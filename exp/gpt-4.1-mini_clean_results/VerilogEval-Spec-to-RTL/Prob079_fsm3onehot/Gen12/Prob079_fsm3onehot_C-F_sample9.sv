module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_bar = ~in;

    // Factor common terms for next_state bits
    assign next_state[0] = in_bar & (A | C);        // A next if in=0 and current A or C
    assign next_state[1] = in & (A | B | D);        // B next if in=1 and current A, B, or D
    assign next_state[2] = in_bar & (B | D);        // C next if in=0 and current B or D
    assign next_state[3] = in & C;                   // D next if in=1 and current C

    assign out = D;                                  // output = 1 only in state D

endmodule