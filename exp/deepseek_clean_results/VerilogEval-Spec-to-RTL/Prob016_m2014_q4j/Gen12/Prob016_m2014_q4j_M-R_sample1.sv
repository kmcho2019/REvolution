module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Bit 0 (LSB)
    wire c0 = 1'b0;  // Ground for first carry-in
    wire c1 = (x[0] & y[0]) | (x[0] & c0) | (y[0] & c0);
    assign sum[0] = x[0] ^ y[0] ^ c0;
    
    // Bit 1
    wire c2 = (x[1] & y[1]) | (x[1] & c1) | (y[1] & c1);
    assign sum[1] = x[1] ^ y[1] ^ c1;
    
    // Bit 2
    wire c3 = (x[2] & y[2]) | (x[2] & c2) | (y[2] & c2);
    assign sum[2] = x[2] ^ y[2] ^ c2;
    
    // Bit 3 (MSB) with carry-out as sum[4]
    wire c4 = (x[3] & y[3]) | (x[3] & c3) | (y[3] & c3);
    assign sum[3] = x[3] ^ y[3] ^ c3;
    assign sum[4] = c4;
endmodule