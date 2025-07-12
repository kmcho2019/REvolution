module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Corrected next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // State A: next y[1] always 0
        (y == 3'b001) ? 1'b1 :  // State B: next y[1] always 1 (C or D)
        (y == 3'b010) ? w :     // State C: next y[1] = w (0->E, 1->D)
        (y == 3'b011) ? ~w :    // State D: next y[1] = ~w (0->F, 1->A)
        (y == 3'b100) ? 1'b1 :  // State E: next y[1] always 1 (self-loop or D)
        (y == 3'b101) ? w;      // State F: next y[1] = w (0->C, 1->D)

endmodule