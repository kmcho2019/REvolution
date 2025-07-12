module TopModule(
    input [3:0] x,  // x[3:2] are row bits, x[1:0] are column bits
    output f
);
    assign f = (x == 4'b0000) |  // row 00, col 00
               (x == 4'b0010) |  // row 00, col 10
               (x == 4'b1100) |  // row 11, col 00
               (x == 4'b1101) |  // row 11, col 01
               (x == 4'b1111) |  // row 11, col 11
               (x == 4'b1000) |  // row 10, col 00
               (x == 4'b1001) |  // row 10, col 01
               (x == 4'b1010);   // row 10, col 10
endmodule