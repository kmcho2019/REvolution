module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next_y1 is 1 if state is B or (C or E) with w=1 or F
    assign Y1 = (y == 3'b001) | (((y == 3'b010) | (y == 3'b100)) & w) | (y == 3'b101);

endmodule