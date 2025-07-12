module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Implement as 4:1 mux with x[3] and x[4] as select lines
    assign f = (~x[3] & ~x[2]) ? 1'b0 :  // x[3]x[4] = 00
               (~x[3] &  x[2]) ? (~x[1] | (x[1] & x[0])) :  // x[3]x[4] = 01
               ( x[3] & ~x[2]) ? ~x[1] :  // x[3]x[4] = 10
               1'b1;                      // x[3]x[4] = 11
endmodule