module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next state logic for y[1]
    // Set to 1 when next state is C(010), D(011), E(100), or F(101)
    wire next_y1;
    assign next_y1 = 
        // From state B (001): transitions to C (010) or D (011)
        (y == 3'b001) |
        
        // From state C (010): transitions to E (100) or D (011)
        (y == 3'b010) |
        
        // From state D (011): transition to F (101) when w=0
        (y == 3'b011 & ~w) |
        
        // From state E (100): stays E (100) or goes to D (011)
        (y == 3'b100) |
        
        // From state F (101): transitions to C (010) or D (011)
        (y == 3'b101);

endmodule