module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    wire next_y1;
    assign Y1 = y[1];

    // Corrected next-state logic for y[1]
    assign next_y1 = (y == 3'b000) ? 1'b0 :               // State A
                    (y == 3'b001) ? w :                   // State B
                    (y == 3'b010) ? w :                   // State C
                    (y == 3'b011) ? 1'b0 :                // State D (fixed)
                    (y == 3'b100) ? w :                   // State E
                    (y == 3'b101) ? 1'b1 :                // State F (fixed)
                    1'b0;                                 // Default case

endmodule