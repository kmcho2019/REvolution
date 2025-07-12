module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Simplified next state logic
    assign next_state[0] = ~in & (A | C);         // Next A
    assign next_state[1] =  in & (A | B | D);     // Next B
    assign next_state[2] = ~in & (B | D);         // Next C
    assign next_state[3] =  in & C;                // Next D

    // Output active only in state D
    assign out = D;

endmodule