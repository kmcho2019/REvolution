module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Stage 0 (LSB)
    wire c0;
    assign sum[0] = x[0] ^ y[0];
    assign c0 = x[0] & y[0];
    
    // Stage 1
    wire c1;
    assign sum[1] = x[1] ^ y[1] ^ c0;
    assign c1 = (x[1] & y[1]) | (x[1] & c0) | (y[1] & c0);
    
    // Stage 2
    wire c2;
    assign sum[2] = x[2] ^ y[2] ^ c1;
    assign c2 = (x[2] & y[2]) | (x[2] & c1) | (y[2] & c1);
    
    // Stage 3 (MSB) with carry-out as sum[4]
    assign sum[3] = x[3] ^ y[3] ^ c2;
    assign sum[4] = (x[3] & y[3]) | (x[3] & c2) | (y[3] & c2);
endmodule