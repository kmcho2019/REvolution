module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = (y == 3'b001 && w) ||  // B and w = 1
                (y == 3'b010 && w) ||  // C and w = 1
                (y == 3'b011) ||       // D
                (y == 3'b100) ||       // E
                (y == 3'b101 && w);    // F and w = 1

endmodule