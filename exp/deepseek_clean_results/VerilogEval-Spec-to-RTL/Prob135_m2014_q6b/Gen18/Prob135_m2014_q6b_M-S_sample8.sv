module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Simplified next-state logic for y[1]
    wire next_y1;
    assign next_y1 = 
        (~w & (y == 3'b010 | y == 3'b011 | y == 3'b100 | y == 3'b101)) |  // C,D,E,F with w=0
        (w & (y == 3'b000 | y == 3'b001 | y == 3'b010));  // A,B,C with w=1

endmodule