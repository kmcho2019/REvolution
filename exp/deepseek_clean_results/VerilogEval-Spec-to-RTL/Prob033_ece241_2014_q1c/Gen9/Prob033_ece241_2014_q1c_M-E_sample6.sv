module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Split into lower and upper 4-bit segments
    wire [3:0] a_low = a[3:0];
    wire [3:0] b_low = b[3:0];
    wire [3:0] a_high = a[7:4];
    wire [3:0] b_high = b[7:4];
    
    // Compute lower 4-bit sum and carry-out
    wire [3:0] sum_low;
    wire cout_low;
    assign {cout_low, sum_low} = a_low + b_low;
    
    // Compute high sums for both carry possibilities
    wire [3:0] sum_high_0, sum_high_1;
    assign sum_high_0 = a_high + b_high;
    assign sum_high_1 = a_high + b_high + 1;
    
    // Final sum selection
    wire [3:0] sum_high = cout_low ? sum_high_1 : sum_high_0;
    assign s = {sum_high, sum_low};
    
    // Early overflow detection (computed in parallel)
    wire msb_same = (a[7] == b[7]);
    wire sum_high_msb = cout_low ? sum_high_1[3] : sum_high_0[3];
    assign overflow = msb_same & (sum_high_msb != a[7]);
endmodule