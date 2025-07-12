module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = (y == 3'b001) | (y == 3'b010) | (y == 3'b011) | (y == 3'b101 & w) | (y == 3'b111 & w);

endmodule