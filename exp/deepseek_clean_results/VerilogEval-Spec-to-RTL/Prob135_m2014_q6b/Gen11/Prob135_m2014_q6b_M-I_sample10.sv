module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (y == 3'b000 | y == 3'b011) ? 1'b0 :  // A or D -> y[1] becomes 0
        1'b1;                                 // All other states -> y[1] becomes 1

endmodule