module TopModule(
    input [3:0] x,
    output f
);
    assign f = (x[3:2] == 2'b00 & x[1:0] == 2'b00) |  // Row 00, Col 00
               (x[3:2] == 2'b00 & x[1:0] == 2'b10) |  // Row 00, Col 10
               (x[3:2] == 2'b11 & x[1:0] == 2'b00) |  // Row 11, Col 00
               (x[3:2] == 2'b11 & x[1:0] == 2'b01) |  // Row 11, Col 01
               (x[3:2] == 2'b11 & x[1:0] == 2'b11) |  // Row 11, Col 11
               (x[3:2] == 2'b10 & x[1:0] == 2'b00) |  // Row 10, Col 00
               (x[3:2] == 2'b10 & x[1:0] == 2'b01) |  // Row 10, Col 01
               (x[3:2] == 2'b10 & x[1:0] == 2'b10);   // Row 10, Col 10
endmodule