module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Early overflow detection (sign bits comparison)
    wire same_sign = (a[7] == b[7]);
    assign overflow = same_sign && ((a[7] ^ s[7]));

    // Lower nibble (4-bit ripple carry adder)
    wire [3:0] sum_lo;
    wire carry_lo;
    
    wire c0 = a[0] & b[0];
    assign sum_lo[0] = a[0] ^ b[0];
    
    wire c1 = (a[1] & b[1]) | ((a[1] ^ b[1]) & c0);
    assign sum_lo[1] = a[1] ^ b[1] ^ c0;
    
    wire c2 = (a[2] & b[2]) | ((a[2] ^ b[2]) & c1);
    assign sum_lo[2] = a[2] ^ b[2] ^ c1;
    
    wire c3 = (a[3] & b[3]) | ((a[3] ^ b[3]) & c2);
    assign sum_lo[3] = a[3] ^ b[3] ^ c2;
    assign carry_lo = c3;

    // Upper nibble (carry-select)
    wire [3:0] sum_hi_0, sum_hi_1;
    
    // Upper nibble with carry=0
    wire s4_0 = a[4] ^ b[4];
    assign sum_hi_0[0] = s4_0;
    wire c4_0 = a[4] & b[4];
    
    wire s5_0 = a[5] ^ b[5] ^ c4_0;
    assign sum_hi_0[1] = s5_0;
    wire c5_0 = (a[5] & b[5]) | ((a[5] ^ b[5]) & c4_0);
    
    wire s6_0 = a[6] ^ b[6] ^ c5_0;
    assign sum_hi_0[2] = s6_0;
    wire c6_0 = (a[6] & b[6]) | ((a[6] ^ b[6]) & c5_0);
    
    wire s7_0 = a[7] ^ b[7] ^ c6_0;
    assign sum_hi_0[3] = s7_0;
    
    // Upper nibble with carry=1
    wire s4_1 = a[4] ^ b[4] ^ 1'b1;
    assign sum_hi_1[0] = s4_1;
    wire c4_1 = (a[4] & b[4]) | ((a[4] ^ b[4]) & 1'b1);
    
    wire s5_1 = a[5] ^ b[5] ^ c4_1;
    assign sum_hi_1[1] = s5_1;
    wire c5_1 = (a[5] & b[5]) | ((a[5] ^ b[5]) & c4_1);
    
    wire s6_1 = a[6] ^ b[6] ^ c5_1;
    assign sum_hi_1[2] = s6_1;
    wire c6_1 = (a[6] & b[6]) | ((a[6] ^ b[6]) & c5_1);
    
    wire s7_1 = a[7] ^ b[7] ^ c6_1;
    assign sum_hi_1[3] = s7_1;
    
    // Final output selection
    assign s[3:0] = sum_lo;
    assign s[7:4] = carry_lo ? sum_hi_1 : sum_hi_0;
endmodule