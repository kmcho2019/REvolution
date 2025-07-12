module TopModule(
    input [3:0] x,  // x[3]x[0]x[1]x[2] mapping (assuming x[4] was typo for x[0])
    output f
);
    // Implement the K-map with optimized don't-care handling
    assign f = (~x[3] & ~x[0] & x[1] & ~x[2]) ? 1'b0 :  // 00_01 = 0
               (~x[3] & x[0] & ~x[1] & ~x[2]) ? 1'b0 :   // 01_00 = 0
               (~x[3] & x[0] & x[1] & x[2]) ? 1'b1 :     // 01_11 = 1
               (~x[3] & x[0] & x[1] & ~x[2]) ? 1'b0 :    // 01_10 = 0
               (x[3] & ~x[0] & ~x[1] & ~x[2]) ? 1'b1 :  // 10_00 = 1
               (x[3] & ~x[0] & ~x[1] & x[2]) ? 1'b1 :    // 10_01 = 1
               (x[3] & ~x[0] & x[1] & x[2]) ? 1'b0 :     // 10_11 = 0
               (x[3] & x[0] & ~x[1] & ~x[2]) ? 1'b1 :    // 11_00 = 1
               (x[3] & x[0] & ~x[1] & x[2]) ? 1'b1 :     // 11_01 = 1
               1'b0;  // All other cases (including don't-cares set to 0)
endmodule