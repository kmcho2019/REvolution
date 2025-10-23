module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] with corrected transitions
    wire next_y1 = 
        // Transitions that set y[1] = 1
        ((y == 3'b001 && w == 1'b1) ||  // B -> D
         (y == 3'b010 && w == 1'b1) ||  // C -> D
         (y == 3'b011 && w == 1'b0) ||  // D -> F
         (y == 3'b100 && w == 1'b1) ||  // E -> D
         (y == 3'b101 && w == 1'b1))    // F -> D
        ? 1'b1 :
        
        // Transitions that set y[1] = 0
        ((y == 3'b000 && w == 1'b0) ||  // A -> B
         (y == 3'b001 && w == 1'b0) ||  // B -> C
         (y == 3'b011 && w == 1'b1) ||  // D -> A
         (y == 3'b101 && w == 1'b0))    // F -> C
        ? 1'b0 :
        
        // Default case (E->E maintains y[1]=1)
        y[1];

endmodule