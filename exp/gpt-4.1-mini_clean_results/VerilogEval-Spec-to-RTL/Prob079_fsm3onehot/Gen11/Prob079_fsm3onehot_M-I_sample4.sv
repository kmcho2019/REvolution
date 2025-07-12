module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // State encoding (one-hot):
    // A = state[0], B = state[1], C = state[2], D = state[3]

    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic derived directly from the state table with minimal expressions

    assign next_state[0] = (~in & (A | C));      // A state if in=0 and current state A or C
    assign next_state[1] = (in & (A | B | D));   // B state if in=1 and current state A, B, or D
    assign next_state[2] = (~in & (B | D));      // C state if in=0 and current state B or D
    assign next_state[3] = (in & C);             // D state if in=1 and current state C

    // Output logic: output = 1 only in state D
    assign out = D;

endmodule