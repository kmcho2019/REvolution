module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire carry_low;
    
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
    assign carry_low = (a[3] & b[3]) | (c3 & (a[3] | b[3]));
    
    // Upper 4-bit carry-select adder
    wire [3:0] sum_high_0;  // Sum if carry_in is 0
    wire [3:0] sum_high_1;  // Sum if carry_in is 1
    wire carry_high_0;      // Carry if carry_in is 0
    wire carry_high_1;      // Carry if carry_in is 1
    
    // Upper adder assuming carry_in = 0
    assign sum_high_0[0] = a[4] ^ b[4] ^ 1'b0;
    wire c4_0 = (a[4] & b[4]) | (1'b0 & (a[4] | b[4]));
    
    assign sum_high_0[1] = a[5] ^ b[5] ^ c4_0;
    wire c5_0 = (a[5] & b[5]) | (c4_0 & (a[5] | b[5]));
    
    assign sum_high_0[2] = a[6] ^ b[6] ^ c5_0;
    wire c6_0 = (a[6] & b[6]) | (c5_0 & (a[6] | b[6]));
    
    assign sum_high_0[3] = a[7] ^ b[7] ^ c6_0;
    assign carry_high_0 = (a[7] & b[7]) | (c6_0 & (a[7] | b[7]));
    
    // Upper adder assuming carry_in = 1
    assign sum_high_1[0] = a[4] ^ b[4] ^ 1'b1;
    wire c4_1 = (a[4] & b[4]) | (1'b1 & (a[4] | b[4]));
    
    assign sum_high_1[1] = a[5] ^ b[5] ^ c4_1;
    wire c5_1 = (a[5] & b[5]) | (c4_1 & (a[5] | b[5]));
    
    assign sum_high_1[2] = a[6] ^ b[6] ^ c5_1;
    wire c6_1 = (a[6] & b[6]) | (c5_1 & (a[6] | b[6]));
    
    assign sum_high_1[3] = a[7] ^ b[7] ^ c6_1;
    assign carry_high_1 = (a[7] & b[7]) | (c6_1 & (a[7] | b[7]));
    
    // Select correct upper sum and carry based on lower carry
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low ? sum_high_1 : sum_high_0;
    assign cout = carry_low ? carry_high_1 : carry_high_0;

endmodule