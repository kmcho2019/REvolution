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

    // Factor input 'in' for next_state[1]
    wire in_and_ABD = in & (A | B | D);

    // Next state logic with reduced terms
    assign next_state[0] = ~in & (A | C);  // A next if in=0 and current state A or C
    assign next_state[1] = in_and_ABD;      // B next if in=1 and current state A,B or D
    assign next_state[2] = ~in & (B | D);  // C next if in=0 and current state B or D
    assign next_state[3] = in & C;          // D next if in=1 and current state C

    // Output logic depends solely on current state D
    assign out = D;

endmodule