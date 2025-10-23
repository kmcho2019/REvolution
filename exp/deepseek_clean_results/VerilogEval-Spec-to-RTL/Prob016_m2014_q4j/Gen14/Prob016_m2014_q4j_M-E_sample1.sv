module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (ripple carry)
    wire [1:0] sum_low;
    wire carry_low;
    
    // First bit
    assign sum_low[0] = x[0] ^ y[0];
    wire carry0 = x[0] & y[0];
    
    // Second bit
    assign sum_low[1] = x[1] ^ y[1] ^ carry0;
    assign carry_low = (x[1] & y[1]) | ((x[1] | y[1]) & carry0);
    
    // Upper 2 bits - compute both possible sums (carry=0 and carry=1)
    wire [1:0] sum_high_c0, sum_high_c1;
    wire carry_high_c0, carry_high_c1;
    
    // Compute upper bits with carry=0
    assign sum_high_c0[0] = x[2] ^ y[2];
    wire carry2_c0 = x[2] & y[2];
    
    assign sum_high_c0[1] = x[3] ^ y[3] ^ carry2_c0;
    assign carry_high_c0 = (x[3] & y[3]) | ((x[3] | y[3]) & carry2_c0);
    
    // Compute upper bits with carry=1
    assign sum_high_c1[0] = x[2] ^ y[2] ^ 1'b1;
    wire carry2_c1 = (x[2] & y[2]) | (x[2] | y[2]);
    
    assign sum_high_c1[1] = x[3] ^ y[3] ^ carry2_c1;
    assign carry_high_c1 = (x[3] & y[3]) | ((x[3] | y[3]) & carry2_c1);
    
    // Select correct upper sum based on lower carry
    assign sum[2] = carry_low ? sum_high_c1[0] : sum_high_c0[0];
    assign sum[3] = carry_low ? sum_high_c1[1] : sum_high_c0[1];
    assign sum[4] = carry_low ? carry_high_c1 : carry_high_c0;
    
    // Combine all bits
    assign sum[1:0] = sum_low;
endmodule