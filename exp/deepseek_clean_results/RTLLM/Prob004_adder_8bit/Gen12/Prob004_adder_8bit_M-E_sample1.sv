module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire c3;
    
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
    assign c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
    assign sum_low[3] = a[3] ^ b[3] ^ c2;
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high_c0, sum_high_c1;
    wire c7_c0, c7_c1;
    
    // Compute upper bits assuming carry-in = 0
    // Bit 4
    wire c4_c0 = (a[4] & b[4]);
    assign sum_high_c0[0] = a[4] ^ b[4];
    
    // Bit 5
    wire c5_c0 = (a[5] & b[5]) | (c4_c0 & (a[5] | b[5]));
    assign sum_high_c0[1] = a[5] ^ b[5] ^ c4_c0;
    
    // Bit 6
    wire c6_c0 = (a[6] & b[6]) | (c5_c0 & (a[6] | b[6]));
    assign sum_high_c0[2] = a[6] ^ b[6] ^ c5_c0;
    
    // Bit 7
    assign c7_c0 = (a[7] & b[7]) | (c6_c0 & (a[7] | b[7]));
    assign sum_high_c0[3] = a[7] ^ b[7] ^ c6_c0;
    
    // Compute upper bits assuming carry-in = 1
    // Bit 4
    wire c4_c1 = (a[4] & b[4]) | (a[4] | b[4]);
    assign sum_high_c1[0] = a[4] ^ b[4] ^ 1'b1;
    
    // Bit 5
    wire c5_c1 = (a[5] & b[5]) | (c4_c1 & (a[5] | b[5]));
    assign sum_high_c1[1] = a[5] ^ b[5] ^ c4_c1;
    
    // Bit 6
    wire c6_c1 = (a[6] & b[6]) | (c5_c1 & (a[6] | b[6]));
    assign sum_high_c1[2] = a[6] ^ b[6] ^ c5_c1;
    
    // Bit 7
    assign c7_c1 = (a[7] & b[7]) | (c6_c1 & (a[7] | b[7]));
    assign sum_high_c1[3] = a[7] ^ b[7] ^ c6_c1;
    
    // Final output selection
    assign sum[3:0] = sum_low;
    assign sum[7:4] = c3 ? sum_high_c1 : sum_high_c0;
    assign cout = c3 ? c7_c1 : c7_c0;

endmodule