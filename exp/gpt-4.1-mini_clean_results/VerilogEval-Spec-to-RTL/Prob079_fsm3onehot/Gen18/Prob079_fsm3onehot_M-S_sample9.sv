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
    wire in_n = ~in;

    // Next state logic from table
    assign next_state[0] = (A & in_n) | (C & in_n); // A or C go to A if in=0
    assign next_state[1] = (A & in) | (B & in) | (D & in); // A, B, D go to B if in=1
    assign next_state[2] = (B & in_n) | (D & in_n); // B or D go to C if in=0
    assign next_state[3] = (C & in); // C goes to D if in=1

    // Output is 1 only when in state D
    assign out = D;

endmodule