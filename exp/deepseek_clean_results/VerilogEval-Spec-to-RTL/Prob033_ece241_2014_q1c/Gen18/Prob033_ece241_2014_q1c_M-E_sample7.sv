module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit segment (ripple carry)
    wire [3:0] sum_low;
    wire carry_low;
    
    // Compute lower sum and carry-out
    assign {carry_low, sum_low} = a[3:0] + b[3:0];
    
    // Upper 4-bit segments (carry-select)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Compute upper sum for both carry-in scenarios
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1;
    
    // Select correct upper sum based on lower carry-out
    wire [3:0] sum_high = carry_low ? sum_high_1 : sum_high_0;
    wire carry_high = carry_low ? carry_high_1 : carry_high_0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Early overflow detection
    wire same_sign = (a[7] == b[7]);
    wire sum_sign = s[7];
    assign overflow = same_sign & (sum_sign != a[7]);
endmodule