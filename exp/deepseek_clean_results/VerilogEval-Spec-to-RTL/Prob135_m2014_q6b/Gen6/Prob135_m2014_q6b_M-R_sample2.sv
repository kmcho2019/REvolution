module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Current y[1] is the output

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // A -> A/B (both have y[1]=0)
        (y == 3'b001) ? w :      // B -> C(0) or D(1)
        (y == 3'b010) ? w :      // C -> E(0) or D(1)
        (y == 3'b011) ? ~w :     // D -> F(1) or A(0)
        (y == 3'b100) ? 1'b1 :   // E -> E(1) or D(1)
        (y == 3'b101) ? w :      // F -> C(0) or D(1)
        1'b0;                    // Default case

endmodule