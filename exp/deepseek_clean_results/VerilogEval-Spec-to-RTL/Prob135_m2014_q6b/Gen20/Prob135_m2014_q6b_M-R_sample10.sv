module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Refactored next-state logic for y[1] using case statement
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // State A: stays 0
        (y == 3'b001) ? w :      // State B: y[1] = w (0→C, 1→D)
        (y == 3'b010) ? 1'b1 :   // State C: always 1 (goes to E or D)
        (y == 3'b011) ? ~w :     // State D: y[1] = ~w (0→F, 1→A)
        (y == 3'b100) ? 1'b1 :  // State E: stays 1 (stays E or goes D)
        (y == 3'b101) ? w :      // State F: y[1] = w (0→C, 1→D)
        1'b0;                    // Default case (shouldn't occur)

endmodule