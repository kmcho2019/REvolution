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

    // Intermediate signals
    wire in_n = ~in;
    wire bd = B | D;
    wire abd = A | bd;

    // Next state logic - slightly optimized factoring for lower gate fan-in
    assign next_state[0] = (A | C) & in_n;    // Next state A for (A or C) and in=0
    assign next_state[1] = in & abd;          // Next state B for in=1 and (A or B or D)
    assign next_state[2] = bd & in_n;         // Next state C for (B or D) and in=0
    assign next_state[3] = C & in;            // Next state D for C and in=1

    // Moore output active only in state D
    assign out = D;

endmodule