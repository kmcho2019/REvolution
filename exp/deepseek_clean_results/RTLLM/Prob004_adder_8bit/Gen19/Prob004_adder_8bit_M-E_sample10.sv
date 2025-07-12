/**
 * 8-bit Hybrid Carry-Select Adder
 * Combines ripple-carry for lower bits with carry-select for upper bits
 * Optimized for speed while maintaining reasonable area
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire c4;  // Carry out from lower 4 bits
    
    // Bit 0
    wire c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    assign sum_low[0] = a[0] ^ b[0] ^ cin;
    
    // Bit 1
    wire c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));
    assign sum_low[1] = a[1] ^ b[1] ^ c0;
    
    // Bit 2
    wire c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));
    assign sum_low[2] = a[2] ^ b[2] ^ c1;
    
    // Bit 3
    assign c4 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
    assign sum_low[3] = a[3] ^ b[3] ^ c2;
    
    // Upper 4-bit carry-select logic
    wire [3:0] sum_high_0;  // Sum assuming carry=0
    wire [3:0] sum_high_1;  // Sum assuming carry=1
    wire c8_0, c8_1;        // Possible carry-outs
    
    // Upper bits with carry=0 assumption
    // Bit 4
    wire c5_0 = (a[4] & b[4]);
    assign sum_high_0[0] = a[4] ^ b[4];
    
    // Bit 5
    wire c6_0 = (a[5] & b[5]) | (c5_0 & (a[5] | b[5]));
    assign sum_high_0[1] = a[5] ^ b[5] ^ c5_0;
    
    // Bit 6
    wire c7_0 = (a[6] & b[6]) | (c6_0 & (a[6] | b[6]));
    assign sum_high_0[2] = a[6] ^ b[6] ^ c6_0;
    
    // Bit 7
    assign c8_0 = (a[7] & b[7]) | (c7_0 & (a[7] | b[7]));
    assign sum_high_0[3] = a[7] ^ b[7] ^ c7_0;
    
    // Upper bits with carry=1 assumption
    // Bit 4
    wire c5_1 = (a[4] & b[4]) | (a[4] | b[4]);
    assign sum_high_1[0] = a[4] ^ b[4] ^ 1'b1;
    
    // Bit 5
    wire c6_1 = (a[5] & b[5]) | (c5_1 & (a[5] | b[5]));
    assign sum_high_1[1] = a[5] ^ b[5] ^ c5_1;
    
    // Bit 6
    wire c7_1 = (a[6] & b[6]) | (c6_1 & (a[6] | b[6]));
    assign sum_high_1[2] = a[6] ^ b[6] ^ c6_1;
    
    // Bit 7
    assign c8_1 = (a[7] & b[7]) | (c7_1 & (a[7] | b[7]));
    assign sum_high_1[3] = a[7] ^ b[7] ^ c7_1;
    
    // Final output selection
    assign sum[3:0] = sum_low;
    assign sum[7:4] = c4 ? sum_high_1 : sum_high_0;
    assign cout = c4 ? c8_1 : c8_0;

endmodule