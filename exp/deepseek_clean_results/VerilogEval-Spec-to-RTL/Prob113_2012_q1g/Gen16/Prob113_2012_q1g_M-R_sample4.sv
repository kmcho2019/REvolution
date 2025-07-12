module TopModule(
    input [3:0] x,
    output f
);
    assign f = (x == 4'b0000) |  // Row 00, Col 00
               (x == 4'b0010) |  // Row 00, Col 10
               (x == 4'b1100) |  // Row 11, Col 00
               (x == 4'b1101) |  // Row 11, Col 01
               (x == 4'b1111) |  // Row 11, Col 11
               (x == 4'b1000) |  // Row 10, Col 00
               (x == 4'b1001);   // Row 10, Col 01
endmodule