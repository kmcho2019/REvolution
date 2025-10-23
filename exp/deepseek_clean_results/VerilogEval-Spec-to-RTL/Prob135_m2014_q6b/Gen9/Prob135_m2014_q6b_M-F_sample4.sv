module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000 && w == 1'b0) ? 1'b0 :  // A -> B (001)
        (y == 3'b000 && w == 1'b1) ? 1'b0 :  // A -> A (000)
        (y == 3'b001 && w == 1'b0) ? 1'b1 :  // B -> C (010)
        (y == 3'b001 && w == 1'b1) ? 1'b1 :  // B -> D (011)
        (y == 3'b010 && w == 1'b0) ? 1'b1 :  // C -> E (110)
        (y == 3'b010 && w == 1'b1) ? 1'b1 :  // C -> D (011)
        (y == 3'b011 && w == 1'b0) ? 1'b1 :  // D -> F (111)
        (y == 3'b011 && w == 1'b1) ? 1'b0 :  // D -> A (000)
        (y == 3'b110 && w == 1'b0) ? 1'b1 :  // E -> E (110)
        (y == 3'b110 && w == 1'b1) ? 1'b1 :  // E -> D (011)
        (y == 3'b111 && w == 1'b0) ? 1'b1 :  // F -> C (010)
        (y == 3'b111 && w == 1'b1) ? 1'b1 :  // F -> D (011)
        y[1];  // Default to current value if unspecified (shouldn't occur)

endmodule