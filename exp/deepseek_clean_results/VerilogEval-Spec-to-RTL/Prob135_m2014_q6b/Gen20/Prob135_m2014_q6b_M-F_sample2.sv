module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    wire next_y1;  // Explicit declaration
    
    assign Y1 = y[1];

    // Next state logic for y[1]
    // Set to 1 when next state is C(010), D(011), E(100), or F(101)
    assign next_y1 = 
        // From state B (001)
        (y == 3'b001) |  // B->C (010) on w=0 or B->D (011) on w=1 - both have y[1]=1
        
        // From state C (010)
        (y == 3'b010) |   // C->E (100) on w=0 or C->D (011) on w=1 - both have y[1]=1
        
        // From state D (011)
        (y == 3'b011 & ~w) |  // D->F (101) on w=0 (y[1]=1)
        
        // From state E (100)
        (y == 3'b100 & ~w) |   // E stays E (100) on w=0
        (y == 3'b100 & w)  |    // E->D (011) on w=1
        
        // From state F (101)
        (y == 3'b101 & ~w) |    // F->C (010) on w=0
        (y == 3'b101 & w);       // F->D (011) on w=1

endmodule