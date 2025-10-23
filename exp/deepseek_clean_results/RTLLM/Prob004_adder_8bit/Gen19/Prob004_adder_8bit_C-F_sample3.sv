/**
 * Optimized 8-bit Ripple Carry Adder
 * 
 * Features:
 * - Clear bit-level implementation for each full adder
 * - Efficient majority function carry computation
 * - Well-documented carry chain with named wires
 * - Direct carry-out assignment
 * - Maintains excellent power/area characteristics
 *
 * Parameters:
 * @param a[7:0]    First 8-bit operand
 * @param b[7:0]    Second 8-bit operand
 * @param cin       Carry-in bit
 * @output sum[7:0] 8-bit sum result
 * @output cout    Final carry-out bit
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry chain wires - explicitly named for clarity
    wire c0, c1, c2, c3, c4, c5, c6;

    // Bit 0: Full adder with external carry-in
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));

    // Bit 1: Full adder with carry from bit 0
    assign sum[1] = a[1] ^ b[1] ^ c0;
    assign c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));

    // Bit 2: Full adder with carry from bit 1
    assign sum[2] = a[2] ^ b[2] ^ c1;
    assign c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));

    // Bit 3: Full adder with carry from bit 2
    assign sum[3] = a[3] ^ b[3] ^ c2;
    assign c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));

    // Bit 4: Full adder with carry from bit 3
    assign sum[4] = a[4] ^ b[4] ^ c3;
    assign c4 = (a[4] & b[4]) | (c3 & (a[4] | b[4]));

    // Bit 5: Full adder with carry from bit 4
    assign sum[5] = a[5] ^ b[5] ^ c4;
    assign c5 = (a[5] & b[5]) | (c4 & (a[5] | b[5]));

    // Bit 6: Full adder with carry from bit 5
    assign sum[6] = a[6] ^ b[6] ^ c5;
    assign c6 = (a[6] & b[6]) | (c5 & (a[6] | b[6]));

    // Bit 7: Full adder with carry from bit 6
    assign sum[7] = a[7] ^ b[7] ^ c6;
    assign cout = (a[7] & b[7]) | (c6 & (a[7] | b[7]));

endmodule