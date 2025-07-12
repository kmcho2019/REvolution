module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using case statement
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 : // State A: stays 0 (A->A or A->B)
        (y == 3'b001) ? w :     // State B: 1 if w (B->D), else 0 (B->C)
        (y == 3'b010) ? w :     // State C: 1 if w (C->D), else 0 (C->E)
        (y == 3'b011) ? 1'b0 :  // State D: stays 0 (D->F or D->A)
        (y == 3'b100) ? 1'b1 :  // State E: stays 1 (E->E or E->D)
        (y == 3'b101) ? w :     // State F: 1 if w (F->D), else 0 (F->C)
        1'b0;                   // Default case

endmodule