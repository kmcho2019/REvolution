module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Stage 1: Ripple carry for first 2 bits (low area overhead)
    wire [1:0] sum_low;
    wire carry1;
    
    // Bit 0
    assign sum_low[0] = x[0] ^ y[0];
    wire c0 = x[0] & y[0];
    
    // Bit 1
    assign sum_low[1] = x[1] ^ y[1] ^ c0;
    assign carry1 = (x[1] & y[1]) | (x[1] & c0) | (y[1] & c0);
    
    assign sum[0] = sum_low[0];
    assign sum[1] = sum_low[1];
    
    // Stage 2: Carry-select style for upper bits
    wire sum2_c0, sum2_c1;  // Bit 2 sums for carry=0 and carry=1
    wire sum3_c0, sum3_c1;  // Bit 3 sums
    wire carry2_c0, carry2_c1;  // Corresponding carries
    
    // Compute both possibilities for upper bits
    // For carry=0 case
    assign sum2_c0 = x[2] ^ y[2];
    assign carry2_c0 = x[2] & y[2];
    assign sum3_c0 = x[3] ^ y[3] ^ carry2_c0;
    wire carry3_c0 = (x[3] & y[3]) | (x[3] & carry2_c0) | (y[3] & carry2_c0);
    
    // For carry=1 case
    assign sum2_c1 = x[2] ^ y[2] ^ 1'b1;
    assign carry2_c1 = (x[2] & y[2]) | (x[2] & 1'b1) | (y[2] & 1'b1);
    assign sum3_c1 = x[3] ^ y[3] ^ carry2_c1;
    wire carry3_c1 = (x[3] & y[3]) | (x[3] & carry2_c1) | (y[3] & carry2_c1);
    
    // Select correct results based on actual carry from lower bits
    assign sum[2] = carry1 ? sum2_c1 : sum2_c0;
    assign sum[3] = carry1 ? sum3_c1 : sum3_c0;
    assign sum[4] = carry1 ? carry3_c1 : carry3_c0;
endmodule