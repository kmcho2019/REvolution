/**
 * Advanced 8-bit Carry-Skip Adder with Variable Block Sizes
 * 
 * Features:
 * - Hybrid ripple-carry + carry-skip architecture
 * - Optimized 3-2-3 bit block partitioning
 * - Efficient skip logic implementation
 * - Balanced critical path for timing
 * - Reduced power consumption through skip logic
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

    // Block 0: bits 0-2 (3 bits)
    wire [2:0] p0 = a[2:0] ^ b[2:0];
    wire [2:0] g0 = a[2:0] & b[2:0];
    
    wire c0 = (g0[0]) | (p0[0] & cin);
    wire c1 = (g0[1]) | (p0[1] & c0);
    wire c2 = (g0[2]) | (p0[2] & c1);
    wire block0_skip = &p0[2:0];
    
    // Block 1: bits 3-4 (2 bits)
    wire [1:0] p1 = a[4:3] ^ b[4:3];
    wire [1:0] g1 = a[4:3] & b[4:3];
    
    wire c3 = (g1[0]) | (p1[0] & (block0_skip ? cin : c2));
    wire c4 = (g1[1]) | (p1[1] & c3);
    wire block1_skip = &p1[1:0];
    
    // Block 2: bits 5-7 (3 bits)
    wire [2:0] p2 = a[7:5] ^ b[7:5];
    wire [2:0] g2 = a[7:5] & b[7:5];
    
    wire c5 = (g2[0]) | (p2[0] & (block1_skip ? (block0_skip ? cin : c2) : c4));
    wire c6 = (g2[1]) | (p2[1] & c5);
    wire c7 = (g2[2]) | (p2[2] & c6);
    
    // Sum computation
    assign sum[0] = p0[0] ^ cin;
    assign sum[1] = p0[1] ^ c0;
    assign sum[2] = p0[2] ^ c1;
    assign sum[3] = p1[0] ^ (block0_skip ? cin : c2);
    assign sum[4] = p1[1] ^ c3;
    assign sum[5] = p2[0] ^ (block1_skip ? (block0_skip ? cin : c2) : c4);
    assign sum[6] = p2[1] ^ c5;
    assign sum[7] = p2[2] ^ c6;
    
    // Carry out
    assign cout = c7;

endmodule