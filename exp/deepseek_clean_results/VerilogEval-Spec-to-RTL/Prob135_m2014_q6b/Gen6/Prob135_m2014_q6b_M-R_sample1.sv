module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1 = 
        // Transitions where y[1] becomes 1
        ((y == 3'b001) & w) |  // B->D
        ((y == 3'b010) & w) |  // C->D
        ((y == 3'b100) & w) |  // E->D
        // Cases where y[1] stays 1 (only possible in D state)
        ((y == 3'b011) & y[1]) |
        // Cases where y[1] stays 0 (not covered by above)
        (~((y == 3'b000) & ~w) &  // Not A->B
         ~((y == 3'b001) & ~w) &  // Not B->C
         ~((y == 3'b011) & w) &   // Not D->A
         ~((y == 3'b101) & ~w) &  // Not F->C
         y[1]);                   // Maintain if none of above

endmodule