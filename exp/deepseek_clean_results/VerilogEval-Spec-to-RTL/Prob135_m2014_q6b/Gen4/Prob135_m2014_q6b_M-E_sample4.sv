module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Current y[1] is the output

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        // Transitions to D (011) where y[1]=1
        ((y == 3'b001 && w) ||  // B->D
        ((y == 3'b010 && w) ||  // C->D
        ((y == 3'b100 && w) ||  // E->D
        ((y == 3'b101 && w))    // F->D
        // All other transitions result in y[1]=0
        // Note: C->E (y=010,w=0) results in E (100) where y[1]=0
        // which is already covered by default case
        ;

endmodule