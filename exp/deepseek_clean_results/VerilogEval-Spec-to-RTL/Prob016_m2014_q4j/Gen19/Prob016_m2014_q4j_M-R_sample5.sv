module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Bit 0
    wire sum0 = x[0] ^ y[0];
    wire c0 = x[0] & y[0];
    assign sum[0] = sum0;
    
    // Bit 1
    wire sum1 = x[1] ^ y[1] ^ c0;
    wire c1 = (x[1] & y[1]) | ((x[1] ^ y[1]) & c0);
    assign sum[1] = sum1;
    
    // Bit 2
    wire sum2 = x[2] ^ y[2] ^ c1;
    wire c2 = (x[2] & y[2]) | ((x[2] ^ y[2]) & c1);
    assign sum[2] = sum2;
    
    // Bit 3 (MSB) with carry lookahead
    wire p3 = x[3] ^ y[3];
    wire g3 = x[3] & y[3];
    assign sum[3] = p3 ^ c2;
    assign sum[4] = g3 | (p3 & c2);
endmodule