module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Carry signals
    wire c0, c1, c2, c3;
    
    // Bit 0
    wire s0 = x[0] ^ y[0];
    assign sum[0] = s0;
    assign c0 = x[0] & y[0];
    
    // Bit 1
    wire s1 = x[1] ^ y[1];
    assign sum[1] = s1 ^ c0;
    wire g1 = x[1] & y[1];
    wire p1 = s1;
    assign c1 = g1 | (p1 & c0);
    
    // Bit 2
    wire s2 = x[2] ^ y[2];
    assign sum[2] = s2 ^ c1;
    wire g2 = x[2] & y[2];
    wire p2 = s2;
    assign c2 = g2 | (p2 & c1);
    
    // Bit 3
    wire s3 = x[3] ^ y[3];
    assign sum[3] = s3 ^ c2;
    wire g3 = x[3] & y[3];
    wire p3 = s3;
    assign c3 = g3 | (p3 & c2);
    
    // Overflow bit
    assign sum[4] = c3;
endmodule