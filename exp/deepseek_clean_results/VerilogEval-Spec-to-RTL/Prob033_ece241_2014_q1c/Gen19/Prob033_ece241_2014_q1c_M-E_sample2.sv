module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit addition (ripple carry)
    wire [3:0] sum_low = a[3:0] + b[3:0];
    wire carry_low = (a[3] & b[3]) | ((a[3] | b[3]) & (a[2] & b[2] | ((a[2] | b[2]) & 
                 (a[1] & b[1] | ((a[1] | b[1]) & (a[0] & b[0]))))));

    // Upper 4-bit additions (both carry scenarios)
    wire [3:0] sum_high_0 = a[7:4] + b[7:4];
    wire [3:0] sum_high_1 = a[7:4] + b[7:4] + 1;
    
    // Final sum selection
    assign s = {carry_low ? sum_high_1 : sum_high_0, sum_low};
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = carry_low ? sum_high_1[3] : sum_high_0[3];
    
    // Overflow occurs if:
    // 1. Both inputs positive but sum negative, OR
    // 2. Both inputs negative but sum positive
    assign overflow = (~sign_a & ~sign_b & sign_sum) | 
                     (sign_a & sign_b & ~sign_sum);
endmodule