module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit adder (ripple carry)
    wire [3:0] sum_low = a[3:0] + b[3:0];
    wire carry_low = (a[3] & b[3]) | ((a[3] | b[3]) & (a[2] & b[2] | 
                     ((a[2] | b[2]) & (a[1] & b[1] | ((a[1] | b[1]) & 
                     (a[0] & b[0])))));
    
    // Upper 4-bit adders (carry-select)
    wire [3:0] sum_high_c0 = a[7:4] + b[7:4];
    wire [3:0] sum_high_c1 = a[7:4] + b[7:4] + 1;
    
    // Select correct upper sum based on lower carry
    wire [3:0] sum_high = carry_low ? sum_high_c1 : sum_high_c0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Early overflow prediction
    wire ovf_c0 = (a[7] == b[7]) && (sum_high_c0[3] != a[7]);
    wire ovf_c1 = (a[7] == b[7]) && (sum_high_c1[3] != a[7]);
    assign overflow = carry_low ? ovf_c1 : ovf_c0;
endmodule