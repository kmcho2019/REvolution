module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire c0, c1, c2, c3;
    
    // Bit 0
    assign sum[0] = x[0] ^ y[0];
    assign c0 = x[0] & y[0];
    
    // Bit 1
    assign sum[1] = x[1] ^ y[1] ^ c0;
    assign c1 = (x[1] & y[1]) | ((x[1] | y[1]) & c0);
    
    // Bit 2
    assign sum[2] = x[2] ^ y[2] ^ c1;
    assign c2 = (x[2] & y[2]) | ((x[2] | y[2]) & c1);
    
    // Bit 3
    assign sum[3] = x[3] ^ y[3] ^ c2;
    assign c3 = (x[3] & y[3]) | ((x[3] | y[3]) & c2);
    
    // Overflow bit
    assign sum[4] = c3;
endmodule