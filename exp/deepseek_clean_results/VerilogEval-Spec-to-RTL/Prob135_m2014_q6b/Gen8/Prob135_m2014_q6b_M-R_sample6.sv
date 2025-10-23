module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next-state logic for y[1] - all cases explicitly covered
    wire next_y1;
    assign next_y1 = 
        // Transitions where y[1] becomes 1
        ((y == 3'b001 && w) ||    // B->D
         (y == 3'b010 && w) ||     // C->D
         (y == 3'b011 && ~w) ||    // D->F (y[1] stays 1)
         (y == 3'b100 && w) ||     // E->D
         (y == 3'b101 && w)) ? 1'b1 :  // F->D
        
        // States where y[1] stays the same
        ((y == 3'b000 && w) ||     // A stays A
         (y == 3'b100 && ~w)) ? y[1] :  // E stays E
        
        // All other cases (transitions to B, C) set y[1] to 0
        1'b0;

endmodule