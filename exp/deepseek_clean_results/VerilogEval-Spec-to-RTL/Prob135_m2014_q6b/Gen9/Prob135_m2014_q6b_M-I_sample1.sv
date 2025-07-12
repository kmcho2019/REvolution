module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? (w ? 1'b0 : 1'b0) :  // A->A (0) or A->B (0)
        (y == 3'b001) ? (w ? 1'b1 : 1'b0) :  // B->D (1) or B->C (0)
        (y == 3'b010) ? (w ? 1'b1 : 1'b0) :  // C->D (1) or C->E (0)
        (y == 3'b011) ? (w ? 1'b0 : 1'b0) :  // D->A (0) or D->F (1) but F's y[1] is 0
        (y == 3'b100) ? (w ? 1'b1 : 1'b0) :  // E->D (1) or E->E (0)
        (y == 3'b101) ? (w ? 1'b1 : 1'b0) :  // F->D (1) or F->C (0)
        1'b0;  // default (shouldn't occur)

endmodule