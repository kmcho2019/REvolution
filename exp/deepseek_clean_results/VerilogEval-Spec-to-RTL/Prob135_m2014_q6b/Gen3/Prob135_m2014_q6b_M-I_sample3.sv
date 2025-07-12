module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b001 && w == 1'b1) ||  // B -> D (y[1] becomes 1)
        (y == 3'b010 && w == 1'b1) ||  // C -> D (y[1] becomes 1)
        (y == 3'b010 && w == 1'b0) ||  // C -> E (y[1] becomes 1)
        (y == 3'b011 && w == 1'b0) ||  // D -> F (y[1] stays 1)
        (y == 3'b100 && w == 1'b1) ||  // E -> D (y[1] stays 1)
        (y == 3'b101 && w == 1'b1);    // F -> D (y[1] stays 1)
        // All other cases y[1] becomes 0

endmodule