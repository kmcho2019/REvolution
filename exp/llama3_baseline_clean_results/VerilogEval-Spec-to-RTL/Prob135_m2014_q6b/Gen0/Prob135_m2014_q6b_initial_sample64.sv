module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // next-state logic for y[1]
    assign Y1 = (y == 3'b010) | (y == 3'b011) | (y == 3'b100) | (y == 3'b101);

endmodule