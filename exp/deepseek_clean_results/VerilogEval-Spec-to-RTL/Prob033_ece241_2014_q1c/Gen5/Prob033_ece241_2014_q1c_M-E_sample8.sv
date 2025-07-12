module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit addition
    wire [3:0] sum_low;
    wire carry_low;
    assign {carry_low, sum_low} = a[3:0] + b[3:0];
    
    // Upper 4-bit additions (both carry assumptions)
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    assign {carry_high_0, sum_high_0} = a[7:4] + b[7:4] + 0;
    assign {carry_high_1, sum_high_1} = a[7:4] + b[7:4] + 1;
    
    // Final sum selection
    assign s = {carry_low ? sum_high_1 : sum_high_0, sum_low};
    
    // Early overflow prediction
    wire potential_ovf_0 = (a[7] == b[7]) & (a[7] != sum_high_0[3]);
    wire potential_ovf_1 = (a[7] == b[7]) & (a[7] != sum_high_1[3]);
    assign overflow = carry_low ? potential_ovf_1 : potential_ovf_0;
endmodule