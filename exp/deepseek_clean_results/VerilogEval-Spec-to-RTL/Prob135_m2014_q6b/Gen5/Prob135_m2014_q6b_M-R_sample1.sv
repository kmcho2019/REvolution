module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using continuous assignment
    wire next_y1 = 
        // Transitions where y[1] becomes 1
        ({y, w} == 4'b0011) ? 1'b1 :  // B -> D
        ({y, w} == 4'b0101) ? 1'b1 :   // C -> D
        ({y, w} == 4'b0100) ? 1'b1 :   // C -> E
        ({y, w} == 4'b0110) ? 1'b1 :   // D -> F
        ({y, w} == 4'b1001) ? 1'b1 :   // E -> D
        ({y, w} == 4'b1011) ? 1'b1 :   // F -> D
        
        // Transitions where y[1] stays 1
        ({y, w} == 4'b1000) ? 1'b1 :  // E -> E
        
        // Transitions where y[1] becomes 0
        ({y, w} == 4'b0000) ? 1'b0 :   // A -> B
        ({y, w} == 4'b0010) ? 1'b0 :   // B -> C
        ({y, w} == 4'b0111) ? 1'b0 :   // D -> A
        ({y, w} == 4'b1010) ? 1'b0 :   // F -> C
        
        // Default case (maintain current value)
        y[1];

endmodule