module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] c;  // Carry bits
    
    // Bit 0 (LSB)
    assign sum[0] = x[0] ^ y[0] ^ 1'b0;  // cin = 0 for LSB
    assign c[0] = (x[0] & y[0]) | (x[0] & 1'b0) | (y[0] & 1'b0);
    
    // Bit 1
    assign sum[1] = x[1] ^ y[1] ^ c[0];
    assign c[1] = (x[1] & y[1]) | (x[1] & c[0]) | (y[1] & c[0]);
    
    // Bit 2
    assign sum[2] = x[2] ^ y[2] ^ c[1];
    assign c[2] = (x[2] & y[2]) | (x[2] & c[1]) | (y[2] & c[1]);
    
    // Bit 3 (MSB)
    assign sum[3] = x[3] ^ y[3] ^ c[2];
    assign sum[4] = (x[3] & y[3]) | (x[3] & c[2]) | (y[3] & c[2]);  // Final carry becomes sum[4]
endmodule