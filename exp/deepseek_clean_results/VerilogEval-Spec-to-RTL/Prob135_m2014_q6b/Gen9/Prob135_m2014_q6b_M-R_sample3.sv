module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

wire y1_next;

// Corrected priority-encoded next-state logic for y[1]
assign y1_next = 
    (y == 3'b000) ? 1'b0 :          // State A: y[1] stays 0
    (y == 3'b001) ? 1'b0 :           // State B: y[1] becomes 0 (B→A or B→C)
    (y == 3'b010) ? w :              // State C: y[1] = w (0→E, 1→D)
    (y == 3'b011) ? ~w :             // State D: y[1] = ~w (0→F, 1→A)
    (y == 3'b100) ? w :              // State E: y[1] = w (0→E, 1→D)
    (y == 3'b101) ? ~w :             // State F: y[1] = ~w (0→C, 1→D)
    1'b0;                            // Default case (shouldn't occur)

endmodule