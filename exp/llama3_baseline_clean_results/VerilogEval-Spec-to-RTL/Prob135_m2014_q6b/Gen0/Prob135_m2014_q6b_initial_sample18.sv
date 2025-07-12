module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    // Next-state logic for y[1]
    assign Y1 = (y == 3'b000 && w) || (y == 3'b001 && w) || (y == 3'b100) || (y == 3'b101);

endmodule