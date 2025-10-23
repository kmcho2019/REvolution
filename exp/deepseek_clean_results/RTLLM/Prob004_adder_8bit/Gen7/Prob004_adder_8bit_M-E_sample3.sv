module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] sum_low;
    wire [4:0] carry_low;
    assign carry_low[0] = cin;
    
    assign sum_low[0] = a[0] ^ b[0] ^ carry_low[0];
    assign carry_low[1] = (a[0] & b[0]) | (carry_low[0] & (a[0] | b[0]));
    
    assign sum_low[1] = a[1] ^ b[1] ^ carry_low[1];
    assign carry_low[2] = (a[1] & b[1]) | (carry_low[1] & (a[1] | b[1]));
    
    assign sum_low[2] = a[2] ^ b[2] ^ carry_low[2];
    assign carry_low[3] = (a[2] & b[2]) | (carry_low[2] & (a[2] | b[2]));
    
    assign sum_low[3] = a[3] ^ b[3] ^ carry_low[3];
    assign carry_low[4] = (a[3] & b[3]) | (carry_low[3] & (a[3] | b[3]));
    
    // Upper 4-bit carry-select adders
    wire [3:0] sum_high_0;  // Upper sum assuming carry-in 0
    wire [3:0] sum_high_1;  // Upper sum assuming carry-in 1
    wire carry_high_0;      // Upper carry assuming carry-in 0
    wire carry_high_1;      // Upper carry assuming carry-in 1
    
    // Upper adder with carry-in 0
    assign sum_high_0[0] = a[4] ^ b[4] ^ 1'b0;
    wire c1_0 = (a[4] & b[4]) | (1'b0 & (a[4] | b[4]));
    
    assign sum_high_0[1] = a[5] ^ b[5] ^ c1_0;
    wire c2_0 = (a[5] & b[5]) | (c1_0 & (a[5] | b[5]));
    
    assign sum_high_0[2] = a[6] ^ b[6] ^ c2_0;
    wire c3_0 = (a[6] & b[6]) | (c2_0 & (a[6] | b[6]));
    
    assign sum_high_0[3] = a[7] ^ b[7] ^ c3_0;
    assign carry_high_0 = (a[7] & b[7]) | (c3_0 & (a[7] | b[7]));
    
    // Upper adder with carry-in 1
    assign sum_high_1[0] = a[4] ^ b[4] ^ 1'b1;
    wire c1_1 = (a[4] & b[4]) | (1'b1 & (a[4] | b[4]));
    
    assign sum_high_1[1] = a[5] ^ b[5] ^ c1_1;
    wire c2_1 = (a[5] & b[5]) | (c1_1 & (a[5] | b[5]));
    
    assign sum_high_1[2] = a[6] ^ b[6] ^ c2_1;
    wire c3_1 = (a[6] & b[6]) | (c2_1 & (a[6] | b[6]));
    
    assign sum_high_1[3] = a[7] ^ b[7] ^ c3_1;
    assign carry_high_1 = (a[7] & b[7]) | (c3_1 & (a[7] | b[7]));
    
    // Select correct upper sum and carry based on lower carry-out
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low[4] ? sum_high_1 : sum_high_0;
    assign cout = carry_low[4] ? carry_high_1 : carry_high_0;
    
endmodule