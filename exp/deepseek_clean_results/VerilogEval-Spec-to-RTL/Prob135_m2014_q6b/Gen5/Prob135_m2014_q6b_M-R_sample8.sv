module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using continuous assignment
    wire next_y1 = 
        // Conditions where y[1] becomes 1
        ((y == 3'b001) & w |  // B -> D
         (y == 3'b010) & w |  // C -> D
         (y == 3'b010) & ~w |  // C -> E
         (y == 3'b011) & ~w |  // D -> F
         (y == 3'b100) & w |   // E -> D
         (y == 3'b101) & w) |  // F -> D
        // Conditions where y[1] stays 1
        ((y == 3'b100) & ~w) | // E -> E
        // Conditions where y[1] becomes 0 are handled by the OR terms below
        // All other cases maintain current y[1]
        y[1] & ~(
            // Conditions where y[1] should be 0
            ((y == 3'b000) & ~w |  // A -> B
             (y == 3'b001) & ~w |  // B -> C
             (y == 3'b011) & w |   // D -> A
             (y == 3'b101) & ~w)   // F -> C
        );

endmodule