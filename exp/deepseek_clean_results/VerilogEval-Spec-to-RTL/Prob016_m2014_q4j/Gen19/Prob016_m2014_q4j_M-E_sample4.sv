module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (0-1) - simple ripple carry
    wire lower_carry;
    wire [1:0] lower_sum;
    
    // Bit 0
    assign lower_sum[0] = x[0] ^ y[0];
    wire carry0 = x[0] & y[0];
    
    // Bit 1
    assign lower_sum[1] = x[1] ^ y[1] ^ carry0;
    assign lower_carry = (x[1] & y[1]) | ((x[1] | y[1]) & carry0);
    
    // Upper 2 bits (2-3) - carry-select
    wire [1:0] upper_sum0;  // sum if carry_in=0
    wire [1:0] upper_sum1;  // sum if carry_in=1
    wire upper_carry0;      // carry if carry_in=0
    wire upper_carry1;      // carry if carry_in=1
    
    // Bit 2 with carry_in=0
    assign upper_sum0[0] = x[2] ^ y[2];
    wire carry2_0 = x[2] & y[2];
    
    // Bit 3 with carry_in=0
    assign upper_sum0[1] = x[3] ^ y[3] ^ carry2_0;
    assign upper_carry0 = (x[3] & y[3]) | ((x[3] | y[3]) & carry2_0);
    
    // Bit 2 with carry_in=1
    assign upper_sum1[0] = x[2] ^ y[2] ^ 1'b1;
    wire carry2_1 = (x[2] & y[2]) | ((x[2] | y[2]) & 1'b1);
    
    // Bit 3 with carry_in=1
    assign upper_sum1[1] = x[3] ^ y[3] ^ carry2_1;
    assign upper_carry1 = (x[3] & y[3]) | ((x[3] | y[3]) & carry2_1);
    
    // Select upper results based on lower carry
    assign sum[2] = lower_carry ? upper_sum1[0] : upper_sum0[0];
    assign sum[3] = lower_carry ? upper_sum1[1] : upper_sum0[1];
    assign sum[4] = lower_carry ? upper_carry1 : upper_carry0;
    
    // Combine lower and upper sums
    assign sum[1:0] = lower_sum;
endmodule