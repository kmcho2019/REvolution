module TopModule(
    input [3:0] x,
    output f
);
    assign f = ((x[3:2] == 2'b00) & (x[0] == 1'b0)) |  // Covers 00 and 10 when x[3:2]=00
               ((x[3:2] == 2'b11) & (x[1] | ~x[0])) |   // Covers 00,01,11 when x[3:2]=11
               ((x[3:2] == 2'b10) & (~x[0]));          // Covers 00 and 10 when x[3:2]=10
endmodule