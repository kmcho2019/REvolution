module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    // Set to 1 when next state is C(010), D(011), E(100), or F(101)
    assign next_y1 = 
        // Current state B (001)
        (y == 3'b001 & ~w) |  // B->C (next state C:010)
        (y == 3'b001 & w)  |   // B->D (next state D:011)
        
        // Current state C (010)
        (y == 3'b010 & ~w) |   // C->E (next state E:100)
        (y == 3'b010 & w)  |   // C->D (next state D:011)
        
        // Current state D (011)
        (y == 3'b011 & w)  |   // D->A (next state A:000) - y[1] should be 0, so not included
        
        // Current state E (100)
        (y == 3'b100)      |   // E stays E (100) or goes to D (011) - both have y[1] = 1
        
        // Current state F (101)
        (y == 3'b101);         // F->C (010) or F->D (011) - both have y[1] = 1

endmodule