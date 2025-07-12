module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Current y[1] is the output

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000 && w == 1'b0) ? 1'b0 :  // A->B (y[1] stays 0)
        (y == 3'b001 && w == 1'b0) ? 1'b0 :   // B->C (y[1] stays 0)
        (y == 3'b001 && w == 1'b1) ? 1'b1 :  // B->D
        (y == 3'b010 && w == 1'b1) ? 1'b1 :  // C->D
        (y == 3'b011 && w == 1'b0) ? 1'b0 :  // D->F (y[1] becomes 0)
        (y == 3'b100 && w == 1'b0) ? 1'b1 :  // E->E (maintain 1)
        (y == 3'b100 && w == 1'b1) ? 1'b1 :  // E->D
        (y == 3'b101 && w == 1'b0) ? 1'b0 :  // F->C (y[1] becomes 0)
        (y == 3'b101 && w == 1'b1) ? 1'b1 :  // F->D
        1'b0;                                // Default case (shouldn't occur)

endmodule