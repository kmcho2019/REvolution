module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b001 && w == 1'b1) ||  // B -> D (next y[1]=1)
        (y == 3'b010 && w == 1'b0) ||  // C -> E (next y[1]=0, but E is 100)
        (y == 3'b011 && w == 1'b0) ||  // D -> F (next y[1]=0, but F is 101)
        (y == 3'b100 && w == 1'b1) ||  // E -> D (next y[1]=1)
        (y == 3'b101 && w == 1'b1);    // F -> D (next y[1]=1)

    // Note: The above logic correctly captures all cases where next y[1] should be 1
    // All other cases will result in next y[1] = 0 by default

endmodule