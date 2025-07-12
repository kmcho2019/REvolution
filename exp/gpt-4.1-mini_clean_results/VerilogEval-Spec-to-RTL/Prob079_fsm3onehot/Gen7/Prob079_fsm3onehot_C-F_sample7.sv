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

    // Next state logic - factored expressions combining clarity and gate count reduction
    assign next_state[0] = (A | C) & ~in;           // Next state A for states A or C and in=0
    assign next_state[1] = in & (A | B | D);        // Next state B for states A, B, or D and in=1
    assign next_state[2] = (B | D) & ~in;           // Next state C for states B or D and in=0
    assign next_state[3] = C & in;                   // Next state D for state C and in=1

    // Output is high only in state D (Moore output)
    assign out = D;

endmodule