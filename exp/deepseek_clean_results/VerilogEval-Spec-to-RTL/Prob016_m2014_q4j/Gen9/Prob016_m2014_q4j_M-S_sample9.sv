module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Bit 0
    assign sum[0] = x[0] ^ y[0];
    
    // Bit 1
    assign sum[1] = x[1] ^ y[1] ^ (x[0] & y[0]);
    
    // Bit 2
    assign sum[2] = x[2] ^ y[2] ^ ((x[1] & y[1]) | ((x[1] | y[1]) & (x[0] & y[0])));
    
    // Bit 3
    assign sum[3] = x[3] ^ y[3] ^ ((x[2] & y[2]) | ((x[2] | y[2]) & ((x[1] & y[1]) | ((x[1] | y[1]) & (x[0] & y[0])))));
    
    // Overflow bit
    assign sum[4] = (x[3] & y[3]) | ((x[3] | y[3]) & ((x[2] & y[2]) | ((x[2] | y[2]) & ((x[1] & y[1]) | ((x[1] | y[1]) & (x[0] & y[0]))))));
endmodule