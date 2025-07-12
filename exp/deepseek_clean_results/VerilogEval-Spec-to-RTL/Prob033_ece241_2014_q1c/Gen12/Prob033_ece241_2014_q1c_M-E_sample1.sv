module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit adder (bits 3:0)
    wire [3:0] sum_low_0, sum_low_1;
    wire carry_low_0, carry_low_1;
    
    // Compute both possible cases (carry-in=0 and carry-in=1)
    assign {carry_low_0, sum_low_0} = a[3:0] + b[3:0] + 1'b0;
    assign {carry_low_1, sum_low_1} = a[3:0] + b[3:0] + 1'b1;
    
    // Upper 4-bit adders (bits 7:4) - both carry cases
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Determine actual carry from lower nibble
    wire actual_carry_low = carry_low_0;  // Since we start with carry-in=0
    
    // Select upper nibble results based on lower nibble carry
    wire [3:0] sum_high = actual_carry_low ? sum_high_1 : sum_high_0;
    wire carry_high = actual_carry_low ? carry_high_1 : carry_high_0;
    
    // Combine final sum
    assign s = {sum_high, actual_carry_low ? sum_low_1 : sum_low_0};
    
    // Early overflow detection (computed in parallel)
    // Overflow occurs if:
    // 1. Both inputs positive and result negative (sum[7]=1)
    // 2. Both inputs negative and result positive (sum[7]=0)
    // We can predict this by examining MSBs before full addition completes
    wire both_positive = ~a[7] & ~b[7];
    wire both_negative = a[7] & b[7];
    wire sum_sign = sum_high[3];  // MSB of upper nibble
    
    assign overflow = (both_positive & sum_sign) | 
                     (both_negative & ~sum_sign);
endmodule