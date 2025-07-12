module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple-carry adder
    wire [3:0] s_low;
    wire carry_low;
    
    assign {carry_low, s_low} = a[3:0] + b[3:0] + 1'b0;
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high_c0, sum_high_c1;
    wire carry_high_c0, carry_high_c1;
    
    // Compute both possible cases (carry_in = 0 or 1)
    assign {carry_high_c0, sum_high_c0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_high_c1, sum_high_c1} = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct upper result based on lower carry
    wire [3:0] s_high = carry_low ? sum_high_c1 : sum_high_c0;
    wire carry_high = carry_low ? carry_high_c1 : carry_high_c0;
    
    // Combine results
    assign s = {s_high, s_low};
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s = s[7];
    
    // Overflow occurs if:
    // 1. Adding two positives gives negative, OR
    // 2. Adding two negatives gives positive
    assign overflow = (~sign_a & ~sign_b & sign_s) | (sign_a & sign_b & ~sign_s);
endmodule