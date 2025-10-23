module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Implement next-state logic for y[1]
    assign Y1 = (y == 3'b000 && w == 1'b0) ||  // A (000) to B (001)
                 (y == 3'b100 && w == 1'b1) ||  // E (100) to D (011)
                 (y == 3'b101 && w == 1'b1);   // F (101) to D (011)

endmodule