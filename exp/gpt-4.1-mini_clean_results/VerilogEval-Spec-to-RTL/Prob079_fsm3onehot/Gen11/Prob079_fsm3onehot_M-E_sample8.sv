module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Decode current one-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic per state bit selected by input 'in'
    // For in=0, next_state: A->A, B->C, C->A, D->C
    // For in=1, next_state: A->B, B->B, C->D, D->B

    wire next_A_0 = A | C;       // in=0 next state A or C leads to A
    wire next_A_1 = 1'b0;        // in=1 next state never A

    wire next_B_0 = 1'b0;        // in=0 next state never B
    wire next_B_1 = A | B | D;   // in=1 next state B if from A,B,D

    wire next_C_0 = B | D;       // in=0 next state C if from B,D
    wire next_C_1 = 1'b0;        // in=1 next state never C

    wire next_D_0 = 1'b0;        // in=0 next state never D
    wire next_D_1 = C;           // in=1 next state D if from C

    assign next_state[0] = (~in & next_A_0) | (in & next_A_1);
    assign next_state[1] = (~in & next_B_0) | (in & next_B_1);
    assign next_state[2] = (~in & next_C_0) | (in & next_C_1);
    assign next_state[3] = (~in & next_D_0) | (in & next_D_1);

    // Output depends only on current state D
    assign out = D;

endmodule