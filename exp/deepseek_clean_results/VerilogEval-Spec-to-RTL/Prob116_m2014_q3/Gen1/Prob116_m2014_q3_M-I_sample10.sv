module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0] - Note: x[4] is actually x[2] in Verilog
    output f
);
    // Mapping:
    // x[3] = x[3]
    // x[4] = x[2]
    // x[1] = x[1]
    // x[2] = x[0]
    assign f = (x[3] & x[2]) | 
               (x[3] & ~x[2] & ~x[1]) | 
               (~x[3] & x[2] & x[1] & x[0]);
endmodule