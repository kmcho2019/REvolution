module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Stage 1: 4:2 compressors for bits 0-3 and 4-7
    wire [3:0] sum_lo, sum_hi;
    wire [3:0] carry_lo, carry_hi;
    wire cout_lo;
    
    // Lower nibble (bits 0-3)
    assign {cout_lo, sum_lo} = a[3:0] + b[3:0];
    assign carry_lo = {cout_lo, sum_lo[3:1]};
    
    // Upper nibble (bits 4-7) with carry-in
    assign sum_hi = a[7:4] + b[7:4] + cout_lo;
    assign carry_hi = sum_hi[3:0];
    
    // Final sum
    assign s = {sum_hi, sum_lo};
    
    // Overflow detection
    wire same_sign = ~(a[7] ^ b[7]);
    wire sum_sign = s[7];
    wire carry_into_msb = (a[6] & b[6]) | (a[6] & cout_lo) | (b[6] & cout_lo);
    assign overflow = same_sign & (sum_sign ^ a[7]) & (a[7] ^ carry_into_msb);
endmodule