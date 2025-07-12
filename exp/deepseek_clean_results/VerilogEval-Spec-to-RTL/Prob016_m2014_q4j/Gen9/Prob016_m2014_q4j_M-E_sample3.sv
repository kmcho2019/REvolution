module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (bits 1:0) - ripple carry
    wire [1:0] sum_low;
    wire carry_low;
    
    // Bit 0
    assign sum_low[0] = x[0] ^ y[0];
    wire c0 = x[0] & y[0];
    
    // Bit 1
    assign sum_low[1] = x[1] ^ y[1] ^ c0;
    assign carry_low = (x[1] & y[1]) | ((x[1] | y[1]) & c0);
    
    // Upper 2 bits (bits 3:2) - carry select
    wire [1:0] sum_high_c0;  // Result if carry-in is 0
    wire [1:0] sum_high_c1;  // Result if carry-in is 1
    wire carry_high_c0;       // Carry-out if carry-in is 0
    wire carry_high_c1;       // Carry-out if carry-in is 1
    
    // Compute both possibilities in parallel
    // Case when carry-in is 0
    assign sum_high_c0[0] = x[2] ^ y[2];
    wire c2_c0 = x[2] & y[2];
    assign sum_high_c0[1] = x[3] ^ y[3] ^ c2_c0;
    assign carry_high_c0 = (x[3] & y[3]) | ((x[3] | y[3]) & c2_c0);
    
    // Case when carry-in is 1
    assign sum_high_c1[0] = x[2] ^ y[2] ^ 1'b1;
    wire c2_c1 = (x[2] & y[2]) | (x[2] & 1'b1) | (y[2] & 1'b1);
    assign sum_high_c1[1] = x[3] ^ y[3] ^ c2_c1;
    assign carry_high_c1 = (x[3] & y[3]) | ((x[3] | y[3]) & c2_c1);
    
    // Select correct upper result based on lower carry
    assign sum[2] = carry_low ? sum_high_c1[0] : sum_high_c0[0];
    assign sum[3] = carry_low ? sum_high_c1[1] : sum_high_c0[1];
    assign sum[4] = carry_low ? carry_high_c1 : carry_high_c0;
    
    // Assign lower bits
    assign sum[1:0] = sum_low;
endmodule