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

    // Next state logic with factored expressions
    assign next_state[0] = (A & in_n) | (C & in_n);       // Next state A
    assign next_state[1] = in & (A | B | D);              // Next state B
    assign next_state[2] = (B | D) & in_n;                // Next state C
    assign next_state[3] = C & in;                         // Next state D

    // Output logic (depends only on state D)
    assign out = D;

endmodule