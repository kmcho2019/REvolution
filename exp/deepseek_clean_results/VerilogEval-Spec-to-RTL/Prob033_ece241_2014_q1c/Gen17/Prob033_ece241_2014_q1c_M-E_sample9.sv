module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower nibble (bits 0-3) - ripple carry adder
    wire [3:0] sum_low;
    wire carry_low;
    
    // Upper nibble (bits 4-7) - carry-select logic
    wire [3:0] sum_high_0, sum_high_1;  // 0/1 carry-in cases
    wire [3:0] sum_high;
    wire carry_high_0, carry_high_1;
    
    // Lower nibble computation
    assign {carry_low, sum_low[0]} = a[0] + b[0];
    assign {sum_low[3:1]} = a[3:1] + b[3:1] + {2'b0, carry_low};
    
    // Upper nibble computations (both carry-in cases)
    // Case 0: carry_in = 0
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4];
    // Case 1: carry_in = 1
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 4'b0001;
    
    // Select correct upper result based on lower carry
    assign sum_high = carry_low ? sum_high_1 : sum_high_0;
    assign carry_high = carry_low ? carry_high_1 : carry_high_0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Early overflow detection
    // Overflow occurs when:
    // 1. Signs of inputs are same
    // 2. Result sign differs from input signs
    // 3. Carry into MSB differs from carry out of MSB
    wire sign_match = (a[7] == b[7]);
    wire result_sign_diff = (s[7] != a[7]);
    wire carry_behavior = (carry_high != carry_low);
    assign overflow = sign_match & (result_sign_diff | carry_behavior);
endmodule