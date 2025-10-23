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

    // Factored next state logic
    assign next_state[0] = (A | C) & ~in;       // Next A
    assign next_state[1] = (A | B | D) & in;    // Next B
    assign next_state[2] = (B | D) & ~in;       // Next C
    assign next_state[3] = C & in;               // Next D

    // Output asserted only in state D
    assign out = D;

endmodule