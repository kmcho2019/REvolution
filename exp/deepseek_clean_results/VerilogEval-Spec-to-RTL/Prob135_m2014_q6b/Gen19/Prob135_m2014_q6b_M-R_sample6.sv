module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Corrected next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // State A -> A(0) or B(0)
        (y == 3'b001) ? w :      // State B -> C(0) or D(1)
        (y == 3'b010) ? w :      // State C -> E(0) or D(1)
        (y == 3'b011) ? ~w :     // State D -> F(1) or A(0)
        (y == 3'b100) ? w :      // State E -> E(0) or D(1)
        (y == 3'b101) ? 1'b1 :   // State F -> C(1) or D(1)
        1'b0;                    // Default

endmodule