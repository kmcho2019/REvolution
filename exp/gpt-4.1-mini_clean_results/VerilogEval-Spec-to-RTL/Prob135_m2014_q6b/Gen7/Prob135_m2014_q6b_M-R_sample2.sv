module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Assign Y1 using direct comparisons for states B(001), C(010), E(100), F(101)
    // next_y1 = B | F | ((C | E) & w);
    assign Y1 = (y == 3'b001) | (y == 3'b101) | (((y == 3'b010) | (y == 3'b100)) & w);

endmodule