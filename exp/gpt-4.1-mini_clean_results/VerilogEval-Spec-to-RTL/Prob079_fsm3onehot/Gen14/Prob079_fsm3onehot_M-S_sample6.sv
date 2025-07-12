module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic without factoring
    assign next_state[0] = (A & ~in) | (C & ~in);
    assign next_state[1] = (A & in) | (B & in) | (D & in);
    assign next_state[2] = (B & ~in) | (D & ~in);
    assign next_state[3] = C & in;

    // Output is 1 only in state D
    assign out = D;

endmodule