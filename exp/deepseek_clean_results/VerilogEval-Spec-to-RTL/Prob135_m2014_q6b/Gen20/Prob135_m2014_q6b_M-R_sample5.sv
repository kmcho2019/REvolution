module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Output is directly y[1]
    assign Y1 = y[1];

    // Next state logic for y[1] using continuous assignment
    wire next_y1 = 
        (y == 3'b000) ? 1'b0 :           // State A: next y[1] is 0
        (y == 3'b001) ? w :               // State B: next y[1] is w
        (y == 3'b010) ? w :               // State C: next y[1] is w
        (y == 3'b011) ? ~w :              // State D: next y[1] is ~w
        (y == 3'b100) ? w :               // State E: next y[1] is w
        (y == 3'b101) ? w :               // State F: next y[1] is w
        1'b0;                             // Default case

endmodule