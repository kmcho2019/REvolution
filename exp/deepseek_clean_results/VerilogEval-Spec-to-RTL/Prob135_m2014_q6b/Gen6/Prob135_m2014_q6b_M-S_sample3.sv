module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Current y[1] is the output

    // Next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        ((y == 3'b001 || y == 3'b010 || y == 3'b100 || y == 3'b101) && w ||  // Transition to D
        (y == 3'b011 && !w);  // Transition to F

endmodule