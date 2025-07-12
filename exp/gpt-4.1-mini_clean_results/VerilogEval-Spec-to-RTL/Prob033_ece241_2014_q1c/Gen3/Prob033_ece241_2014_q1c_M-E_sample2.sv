module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_full = a + b; // 9-bit unsigned sum (includes carry out)

    assign s = sum_full[7:0];

    // Extract carry into MSB (bit 7)
    // Carry into bit 7 equals carry out from bit 6 addition.
    // Compute carry into bit 7 by bitwise addition of lower 7 bits with carry chain.
    // Alternatively, reconstruct carry into bit 7 as:
    // carry_in_bit7 = (a[6] & b[6]) | ((a[6] ^ b[6]) & sum_full[6]);
    wire carry_in_bit7 = (a[6] & b[6]) | ((a[6] ^ b[6]) & sum_full[6]);
    wire carry_out_bit7 = sum_full[8]; // MSB carry out of full addition

    assign overflow = carry_in_bit7 ^ carry_out_bit7;

endmodule