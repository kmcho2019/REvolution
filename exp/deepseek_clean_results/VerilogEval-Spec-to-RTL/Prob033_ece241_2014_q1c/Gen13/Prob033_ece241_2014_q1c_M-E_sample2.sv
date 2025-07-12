module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple carry adder
    wire [3:0] sum_low;
    wire carry_low;
    assign {carry_low, sum_low} = a[3:0] + b[3:0] + 1'b0;
    
    // Upper 4-bit speculative adders (carry0 and carry1 cases)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 1'b0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct upper sum based on lower carry
    wire [3:0] sum_high = carry_low ? sum_high_1 : sum_high_0;
    
    // Combine final sum
    assign s = {sum_high, sum_low};
    
    // Speculative overflow detection (both carry cases)
    wire ovf_0 = (a[7] == b[7]) && (sum_high_0[3] != a[7]);
    wire ovf_1 = (a[7] == b[7]) && (sum_high_1[3] != a[7]);
    
    // Select correct overflow
    assign overflow = carry_low ? ovf_1 : ovf_0;
endmodule