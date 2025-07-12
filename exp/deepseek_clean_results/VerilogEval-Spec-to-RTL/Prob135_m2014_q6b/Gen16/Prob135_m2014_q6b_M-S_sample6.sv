module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y1;

    // Next state logic for y[1]
    assign next_y1 = 
        // Transitions where y[1] becomes 1
        ((y == 3'b001) |           // B->C or B->D
         (y == 3'b010 & w) |        // C->D
         (y == 3'b011 & ~w) |       // D->F
         (y == 3'b101))            // F->C or F->D
        // All other cases maintain current y[1] or set to 0
        ;

endmodule