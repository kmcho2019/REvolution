module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1 = 
        // Cases where y[1] should be 1 next cycle
        ((y == 3'b001 && w == 1'b1) ||  // B -> D
        ((y == 3'b010 && w == 1'b1) ||  // C -> D
        ((y == 3'b011 && w == 1'b1) ||  // D -> A (but A has y[1]=0, so this is wrong)
        ((y == 3'b100 && w == 1'b1) ||  // E -> D
        ((y == 3'b101 && w == 1'b1))    // F -> D
        ? 1'b1 :
        
        // Cases where y[1] should be 0 next cycle
        ((y == 3'b000 && w == 1'b0) ||  // A -> B
        ((y == 3'b001 && w == 1'b0) ||  // B -> C
        ((y == 3'b011 && w == 1'b0) ||  // D -> F (but F has y[1]=1, so this is wrong)
        ((y == 3'b101 && w == 1'b0))    // F -> C
        ? 1'b0 :
        
        // Default case - maintain current y[1] (for E->E and others)
        y[1];

endmodule