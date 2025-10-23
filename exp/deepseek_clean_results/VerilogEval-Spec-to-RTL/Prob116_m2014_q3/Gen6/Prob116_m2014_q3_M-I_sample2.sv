module TopModule(
    input [3:0] x,  // x[3]x[0]x[1]x[2] mapping (treating x[4] as x[0])
    output f
);
    // Optimized logic: f = x[3] OR (NOT x[1] AND NOT x[2])
    assign f = x[3] | (~x[1] & ~x[2]);
endmodule