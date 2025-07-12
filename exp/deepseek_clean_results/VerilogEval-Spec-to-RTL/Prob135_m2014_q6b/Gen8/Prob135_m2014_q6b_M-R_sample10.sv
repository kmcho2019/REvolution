module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Output is simply y[1]
    assign Y1 = y[1];

    // Next-state logic for y[1] only
    wire next_y1 = 
        (y == 3'b000) ? 1'b0 :  // A: next state B (001) or A (000) - y[1] stays 0
        (y == 3'b001) ? w :      // B: next state C (010) or D (011) - y[1] becomes w
        (y == 3'b010) ? w :      // C: next state E (100) or D (011) - y[1] becomes w
        (y == 3'b011) ? ~w :     // D: next state F (101) or A (000) - y[1] becomes ~w
        (y == 3'b100) ? 1'b1 :   // E: next state E (100) or D (011) - y[1] stays 1
        (y == 3'b101) ? w :      // F: next state C (010) or D (011) - y[1] becomes w
        1'b0;                    // default case (shouldn't occur)

endmodule