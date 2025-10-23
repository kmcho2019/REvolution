module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1 = 
        // Transitions where y[1] becomes 1
        ((y == 3'b001 && w) ||  // B->D
         (y == 3'b010 && w) ||  // C->D
         (y == 3'b100 && w) ||  // E->D
         (y == 3'b101 && w))    // F->D
        ? 1'b1 :
        // Transitions where y[1] becomes 0
        ((y == 3'b000 && !w) || // A->B
         (y == 3'b001 && !w) || // B->C
         (y == 3'b011 && w) ||  // D->A
         (y == 3'b101 && !w))   // F->C
        ? 1'b0 :
        // Default case - maintain current y[1]
        y[1];

endmodule