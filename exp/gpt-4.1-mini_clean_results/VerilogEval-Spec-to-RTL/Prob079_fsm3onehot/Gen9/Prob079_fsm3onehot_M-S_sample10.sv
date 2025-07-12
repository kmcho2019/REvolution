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

    assign next_state[0] = (A & ~in) | (C & ~in); // A next if in=0 and current A or C
    assign next_state[1] = (A & in) | (B & in) | (D & in); // B next if in=1 and current A, B, or D
    assign next_state[2] = (B & ~in) | (D & ~in); // C next if in=0 and current B or D
    assign next_state[3] = (C & in);               // D next if in=1 and current C

    assign out = D;

endmodule