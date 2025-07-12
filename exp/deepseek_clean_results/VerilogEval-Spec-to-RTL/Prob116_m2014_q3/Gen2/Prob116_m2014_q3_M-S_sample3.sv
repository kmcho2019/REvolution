module TopModule(
    input [3:0] x,
    output f
);
    // Simplified implementation based on optimal K-map groupings
    // x[3] is MSB, x[0] is LSB in Verilog
    assign f = (x[3] & ~x[2]) |          // Covers 1s in x[3]x[0]=11 and 10 when x[1]x[2]=00
               (~x[3] & x[2] & x[1]) |   // Covers the single 1 in x[3]x[0]=01, x[1]x[2]=11
               (x[3] & x[1]);             // Covers 1s in x[3]x[0]=11 when x[1]x[2]=01
endmodule