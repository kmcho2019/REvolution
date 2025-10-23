module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit addition
    wire [3:0] sum_low = a[3:0] + b[3:0];
    wire carry_low = (a[3] & b[3]) | (a[3] & ~sum_low[3]) | (b[3] & ~sum_low[3]);
    
    // Upper 4-bit additions (for both carry scenarios)
    wire [3:0] sum_high_c0 = a[7:4] + b[7:4];
    wire [3:0] sum_high_c1 = a[7:4] + b[7:4] + 1'b1;
    
    // Select correct upper sum based on lower carry
    wire [3:0] sum_high = carry_low ? sum_high_c1 : sum_high_c0;
    
    // Combine results
    assign s = {sum_high, sum_low};
    
    // Overflow detection (carry into MSB != carry out of MSB)
    wire carry_high = carry_low ? 
                     (a[7] & b[7]) | (a[7] & ~sum_high_c1[3]) | (b[7] & ~sum_high_c1[3]) :
                     (a[7] & b[7]) | (a[7] & ~sum_high_c0[3]) | (b[7] & ~sum_high_c0[3]);
    
    assign overflow = carry_low ^ carry_high;
endmodule