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
    
    // Majority function carry generation
    wire c0 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    wire c1 = (a[1] & b[1]) | (c0 & (a[1] | b[1]));
    wire c2 = (a[2] & b[2]) | (c1 & (a[2] | b[2]));
    wire c3 = (a[3] & b[3]) | (c2 & (a[3] | b[3]));
    
    assign sum_low[0] = a[0] ^ b[0] ^ cin;
    assign sum_low[1] = a[1] ^ b[1] ^ c0;
    assign sum_low[2] = a[2] ^ b[2] ^ c1;
    assign sum_low[3] = a[3] ^ b[3] ^ c2;
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high_0;  // Sum when carry-in is 0
    wire [3:0] sum_high_1;  // Sum when carry-in is 1
    wire c7_0, c7_1;        // Corresponding carry outs
    
    // Upper block with carry-in = 0
    wire c4_0 = (a[4] & b[4]) | (0 & (a[4] | b[4]));
    wire c5_0 = (a[5] & b[5]) | (c4_0 & (a[5] | b[5]));
    wire c6_0 = (a[6] & b[6]) | (c5_0 & (a[6] | b[6]));
    wire c7_0 = (a[7] & b[7]) | (c6_0 & (a[7] | b[7]));
    
    assign sum_high_0[0] = a[4] ^ b[4] ^ 0;
    assign sum_high_0[1] = a[5] ^ b[5] ^ c4_0;
    assign sum_high_0[2] = a[6] ^ b[6] ^ c5_0;
    assign sum_high_0[3] = a[7] ^ b[7] ^ c6_0;
    
    // Upper block with carry-in = 1
    wire c4_1 = (a[4] & b[4]) | (1 & (a[4] | b[4]));
    wire c5_1 = (a[5] & b[5]) | (c4_1 & (a[5] | b[5]));
    wire c6_1 = (a[6] & b[6]) | (c5_1 & (a[6] | b[6]));
    wire c7_1 = (a[7] & b[7]) | (c6_1 & (a[7] | b[7]));
    
    assign sum_high_1[0] = a[4] ^ b[4] ^ 1;
    assign sum_high_1[1] = a[5] ^ b[5] ^ c4_1;
    assign sum_high_1[2] = a[6] ^ b[6] ^ c5_1;
    assign sum_high_1[3] = a[7] ^ b[7] ^ c6_1;
    
    // Final output selection
    assign sum[3:0] = sum_low;
    assign sum[7:4] = c3 ? sum_high_1 : sum_high_0;
    assign cout = c3 ? c7_1 : c7_0;

endmodule