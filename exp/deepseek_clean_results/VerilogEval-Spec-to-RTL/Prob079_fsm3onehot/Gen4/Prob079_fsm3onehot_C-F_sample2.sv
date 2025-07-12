module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Optimized common state combinations
    wire from_A_or_C = state[0] | state[2];
    wire from_B_or_D = state[1] | state[3];
    
    // Next state logic with explicit bitwise operations
    assign next_state[0] = from_A_or_C & ~in;          // A: from A or C when in=0
    assign next_state[1] = in & ~state[2];             // B: from A,B,D when in=1 (not C)
    assign next_state[2] = from_B_or_D & ~in;          // C: from B or D when in=0
    assign next_state[3] = state[2] & in;              // D: from C when in=1

    // Direct output assignment
    assign out = state[3];

endmodule