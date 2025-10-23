module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire carry_mid;
    
    // Full adder for bit 0
    assign sum_low[0] = a[0] ^ b[0] ^ cin;
    wire c1 = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Full adder for bit 1
    assign sum_low[1] = a[1] ^ b[1] ^ c1;
    wire c2 = (a[1] & b[1]) | (c1 & (a[1] | b[1]));
    
    // Full adder for bit 2
    assign sum_low[2] = a[2] ^ b[2] ^ c2;
    wire c3 = (a[2] & b[2]) | (c2 & (a[2] | b[2]));
    
    // Full adder for bit 3
    assign sum_low[3] = a[3] ^ b[3] ^ c3;
    assign carry_mid = (a[3] & b[3]) | (c3 & (a[3] | b[3]));
    
    // Upper 4-bit conditional-sum adder
    wire [3:0] sum_high_0; // Sum if carry_mid = 0
    wire [3:0] sum_high_1; // Sum if carry_mid = 1
    wire cout_0, cout_1;
    
    // Compute both possible sums for upper bits
    // Case 0: carry_mid = 0
    assign sum_high_0[0] = a[4] ^ b[4] ^ 1'b0;
    wire c5_0 = (a[4] & b[4]) | (1'b0 & (a[4] | b[4]));
    
    assign sum_high_0[1] = a[5] ^ b[5] ^ c5_0;
    wire c6_0 = (a[5] & b[5]) | (c5_0 & (a[5] | b[5]));
    
    assign sum_high_0[2] = a[6] ^ b[6] ^ c6_0;
    wire c7_0 = (a[6] & b[6]) | (c6_0 & (a[6] | b[6]));
    
    assign sum_high_0[3] = a[7] ^ b[7] ^ c7_0;
    assign cout_0 = (a[7] & b[7]) | (c7_0 & (a[7] | b[7]));
    
    // Case 1: carry_mid = 1
    assign sum_high_1[0] = a[4] ^ b[4] ^ 1'b1;
    wire c5_1 = (a[4] & b[4]) | (1'b1 & (a[4] | b[4]));
    
    assign sum_high_1[1] = a[5] ^ b[5] ^ c5_1;
    wire c6_1 = (a[5] & b[5]) | (c5_1 & (a[5] | b[5]));
    
    assign sum_high_1[2] = a[6] ^ b[6] ^ c6_1;
    wire c7_1 = (a[6] & b[6]) | (c6_1 & (a[6] | b[6]));
    
    assign sum_high_1[3] = a[7] ^ b[7] ^ c7_1;
    assign cout_1 = (a[7] & b[7]) | (c7_1 & (a[7] | b[7]));
    
    // Select correct upper sum based on actual carry_mid
    assign sum[7:4] = carry_mid ? sum_high_1 : sum_high_0;
    assign sum[3:0] = sum_low;
    assign cout = carry_mid ? cout_1 : cout_0;

endmodule