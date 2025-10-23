module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Transition conditions for Y1 (state B)
    wire A_to_B = y[0] & w;  // A->B when w=1

    // Transition conditions for Y3 (state D)
    wire B_to_D = y[1] & ~w; // B->D when w=0
    wire C_to_D = y[2] & ~w; // C->D when w=0
    wire E_to_D = y[4] & ~w; // E->D when w=0
    wire F_to_D = y[5] & ~w; // F->D when w=0

    // Output assignments
    assign Y1 = A_to_B;  // Only A can transition to B
    assign Y3 = B_to_D | C_to_D | E_to_D | F_to_D;  // All transitions to D

endmodule