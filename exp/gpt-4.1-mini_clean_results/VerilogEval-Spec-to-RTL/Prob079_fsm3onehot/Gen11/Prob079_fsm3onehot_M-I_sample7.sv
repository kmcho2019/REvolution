module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // Decode one-hot states for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Factored next state equations to reduce logic and switching
    assign next_state[0] = ~in & (A | C);
    assign next_state[1] = in  & (A | B | D);
    assign next_state[2] = ~in & (B | D);
    assign next_state[3] = in  & C;

    // Output asserted only in state D
    assign out = D;

endmodule