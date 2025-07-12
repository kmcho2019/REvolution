module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];
    
    // Comprehensive next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000) ? 1'b0 :           // State A
                    (y == 3'b001) ? ~w :              // State B
                    (y == 3'b010) ? 1'b1 :            // State C
                    (y == 3'b011) ? 1'b0 :            // State D
                    (y == 3'b100) ? 1'b1 :            // State E
                    (y == 3'b101) ? 1'b0 :            // State F
                    1'b0;                             // Default (shouldn't occur)

endmodule