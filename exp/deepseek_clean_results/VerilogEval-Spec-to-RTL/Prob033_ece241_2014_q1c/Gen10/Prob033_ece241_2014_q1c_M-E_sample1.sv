module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Low nibble (bits 3:0) addition - ripple carry
    wire [3:0] sum_low;
    wire carry_low;
    
    // Full adder for bit 0
    wire sum0 = a[0] ^ b[0];
    wire c0 = a[0] & b[0];
    assign sum_low[0] = sum0;
    
    // Full adder for bit 1
    wire sum1 = a[1] ^ b[1];
    wire c1 = (a[1] & b[1]) | ((a[1] ^ b[1]) & c0);
    assign sum_low[1] = sum1 ^ c0;
    
    // Full adder for bit 2
    wire sum2 = a[2] ^ b[2];
    wire c2 = (a[2] & b[2]) | ((a[2] ^ b[2]) & c1);
    assign sum_low[2] = sum2 ^ c1;
    
    // Full adder for bit 3
    wire sum3 = a[3] ^ b[3];
    wire c3 = (a[3] & b[3]) | ((a[3] ^ b[3]) & c2);
    assign sum_low[3] = sum3 ^ c2;
    assign carry_low = c3;
    
    // High nibble additions (bits 7:4) - carry-select
    wire [3:0] sum_high_c0;  // Result assuming carry_in=0
    wire [3:0] sum_high_c1;  // Result assuming carry_in=1
    
    // Compute both possible high nibble results in parallel
    assign sum_high_c0 = a[7:4] ^ b[7:4];
    assign sum_high_c1 = a[7:4] ^ b[7:4] ^ 4'b0001;
    
    // Select correct high nibble result based on actual carry
    wire [3:0] sum_high = carry_low ? sum_high_c1 : sum_high_c0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum_c0 = sum_high_c0[3];  // Sign bit when carry_in=0
    wire sign_sum_c1 = sum_high_c1[3];  // Sign bit when carry_in=1
    wire sign_sum = carry_low ? sign_sum_c1 : sign_sum_c0;
    
    // Overflow occurs if:
    // 1. Inputs have same sign
    // 2. Result has different sign
    // 3. And it's not just normal negative result
    assign overflow = (sign_a == sign_b) & (sign_a != sign_sum);
endmodule