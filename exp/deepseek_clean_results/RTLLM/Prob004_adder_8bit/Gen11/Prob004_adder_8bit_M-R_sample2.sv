/**
 * 8-bit Ripple Carry Adder - Explicit Implementation
 * Same functionality as original but with explicit bit-level assignments
 * Optimized carry computation using majority function
 */
module adder_8bit (
    input [7:0] a,     // 8-bit operand A
    input [7:0] b,     // 8-bit operand B
    input cin,         // Carry-in
    output [7:0] sum,  // 8-bit sum output
    output cout        // Carry-out
);

    // Carry chain - each bit's carry out becomes next bit's carry in
    wire c1, c2, c3, c4, c5, c6, c7, c8;

    // Bit 0: Full adder with cin as carry-in
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c1 = (a[0] & b[0]) | (cin & (a[0] | b[0]));

    // Bit 1: Full adder with c1 as carry-in
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign c2 = (a[1] & b[1]) | (c1 & (a[1] | b[1]));

    // Bit 2: Full adder with c2 as carry-in
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign c3 = (a[2] & b[2]) | (c2 & (a[2] | b[2]));

    // Bit 3: Full adder with c3 as carry-in
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign c4 = (a[3] & b[3]) | (c3 & (a[3] | b[3]));

    // Bit 4: Full adder with c4 as carry-in
    assign sum[4] = a[4] ^ b[4] ^ c4;
    assign c5 = (a[4] & b[4]) | (c4 & (a[4] | b[4]));

    // Bit 5: Full adder with c5 as carry-in
    assign sum[5] = a[5] ^ b[5] ^ c5;
    assign c6 = (a[5] & b[5]) | (c5 & (a[5] | b[5]));

    // Bit 6: Full adder with c6 as carry-in
    assign sum[6] = a[6] ^ b[6] ^ c6;
    assign c7 = (a[6] & b[6]) | (c6 & (a[6] | b[6]));

    // Bit 7: Full adder with c7 as carry-in (cout comes from this bit)
    assign sum[7] = a[7] ^ b[7] ^ c7;
    assign cout = (a[7] & b[7]) | (c7 & (a[7] | b[7]));

endmodule