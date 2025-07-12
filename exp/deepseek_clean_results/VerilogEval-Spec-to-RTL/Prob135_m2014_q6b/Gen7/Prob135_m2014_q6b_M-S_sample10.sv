module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next-state logic for y[1] only
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000) ? 1'b0 :  // A -> A/B (both y[1]=0)
        (y == 3'b001) ? w :     // B -> C/D
        (y == 3'b010) ? w :     // C -> E/D
        (y == 3'b011) ? ~w :    // D -> F/A
        (y == 3'b100) ? 1'b1 :  // E -> E/D
        (y == 3'b101) ? w :     // F -> C/D
        1'b0;                   // Default case

endmodule