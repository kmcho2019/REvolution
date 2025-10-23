module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple carry adder
    wire [3:0] sum_low;
    wire carry_low;
    
    // First bit
    wire sum0 = a[0] ^ b[0];
    wire c0 = a[0] & b[0];
    assign sum_low[0] = sum0;
    
    // Second bit
    wire sum1 = a[1] ^ b[1] ^ c0;
    wire c1 = (a[1] & b[1]) | ((a[1] ^ b[1]) & c0);
    assign sum_low[1] = sum1;
    
    // Third bit
    wire sum2 = a[2] ^ b[2] ^ c1;
    wire c2 = (a[2] & b[2]) | ((a[2] ^ b[2]) & c1);
    assign sum_low[2] = sum2;
    
    // Fourth bit
    wire sum3 = a[3] ^ b[3] ^ c2;
    assign sum_low[3] = sum3;
    assign carry_low = (a[3] & b[3]) | ((a[3] ^ b[3]) & c2);
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high0, sum_high1;
    
    // Compute both possible sums (carry-in 0 and 1)
    // For carry-in = 0
    wire sum4_0 = a[4] ^ b[4];
    wire c4_0 = a[4] & b[4];
    assign sum_high0[0] = sum4_0;
    
    wire sum5_0 = a[5] ^ b[5] ^ c4_0;
    wire c5_0 = (a[5] & b[5]) | ((a[5] ^ b[5]) & c4_0);
    assign sum_high0[1] = sum5_0;
    
    wire sum6_0 = a[6] ^ b[6] ^ c5_0;
    wire c6_0 = (a[6] & b[6]) | ((a[6] ^ b[6]) & c5_0);
    assign sum_high0[2] = sum6_0;
    
    wire sum7_0 = a[7] ^ b[7] ^ c6_0;
    assign sum_high0[3] = sum7_0;
    wire cout0 = (a[7] & b[7]) | ((a[7] ^ b[7]) & c6_0);
    
    // For carry-in = 1
    wire sum4_1 = a[4] ^ b[4] ^ 1'b1;
    wire c4_1 = (a[4] & b[4]) | ((a[4] ^ b[4]) & 1'b1);
    assign sum_high1[0] = sum4_1;
    
    wire sum5_1 = a[5] ^ b[5] ^ c4_1;
    wire c5_1 = (a[5] & b[5]) | ((a[5] ^ b[5]) & c4_1);
    assign sum_high1[1] = sum5_1;
    
    wire sum6_1 = a[6] ^ b[6] ^ c5_1;
    wire c6_1 = (a[6] & b[6]) | ((a[6] ^ b[6]) & c5_1);
    assign sum_high1[2] = sum6_1;
    
    wire sum7_1 = a[7] ^ b[7] ^ c6_1;
    assign sum_high1[3] = sum7_1;
    wire cout1 = (a[7] & b[7]) | ((a[7] ^ b[7]) & c6_1);
    
    // Select correct upper sum based on carry from lower bits
    wire [3:0] sum_high = carry_low ? sum_high1 : sum_high0;
    wire final_cout = carry_low ? cout1 : cout0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s = s[7];
    
    // Overflow occurs if:
    // 1. Both inputs are positive and sum is negative, OR
    // 2. Both inputs are negative and sum is positive
    assign overflow = (~sign_a & ~sign_b & sign_s) | (sign_a & sign_b & ~sign_s);
endmodule