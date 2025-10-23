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
    wire [4:0] carry_chain_low;
    
    assign carry_chain_low[0] = cin;
    assign sum_low[0] = a[0] ^ b[0] ^ carry_chain_low[0];
    assign carry_chain_low[1] = (a[0] & b[0]) | (carry_chain_low[0] & (a[0] | b[0]));
    
    assign sum_low[1] = a[1] ^ b[1] ^ carry_chain_low[1];
    assign carry_chain_low[2] = (a[1] & b[1]) | (carry_chain_low[1] & (a[1] | b[1]));
    
    assign sum_low[2] = a[2] ^ b[2] ^ carry_chain_low[2];
    assign carry_chain_low[3] = (a[2] & b[2]) | (carry_chain_low[2] & (a[2] | b[2]));
    
    assign sum_low[3] = a[3] ^ b[3] ^ carry_chain_low[3];
    assign carry_low = (a[3] & b[3]) | (carry_chain_low[3] & (a[3] | b[3]));

    // Upper 4-bit carry-select adders
    wire [3:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Case 0: carry_in = 0
    wire [4:0] carry_chain_high_0;
    assign carry_chain_high_0[0] = 1'b0;
    assign sum_high_0[0] = a[4] ^ b[4] ^ carry_chain_high_0[0];
    assign carry_chain_high_0[1] = (a[4] & b[4]) | (carry_chain_high_0[0] & (a[4] | b[4]));
    
    assign sum_high_0[1] = a[5] ^ b[5] ^ carry_chain_high_0[1];
    assign carry_chain_high_0[2] = (a[5] & b[5]) | (carry_chain_high_0[1] & (a[5] | b[5]));
    
    assign sum_high_0[2] = a[6] ^ b[6] ^ carry_chain_high_0[2];
    assign carry_chain_high_0[3] = (a[6] & b[6]) | (carry_chain_high_0[2] & (a[6] | b[6]));
    
    assign sum_high_0[3] = a[7] ^ b[7] ^ carry_chain_high_0[3];
    assign carry_high_0 = (a[7] & b[7]) | (carry_chain_high_0[3] & (a[7] | b[7]));

    // Case 1: carry_in = 1
    wire [4:0] carry_chain_high_1;
    assign carry_chain_high_1[0] = 1'b1;
    assign sum_high_1[0] = a[4] ^ b[4] ^ carry_chain_high_1[0];
    assign carry_chain_high_1[1] = (a[4] & b[4]) | (carry_chain_high_1[0] & (a[4] | b[4]));
    
    assign sum_high_1[1] = a[5] ^ b[5] ^ carry_chain_high_1[1];
    assign carry_chain_high_1[2] = (a[5] & b[5]) | (carry_chain_high_1[1] & (a[5] | b[5]));
    
    assign sum_high_1[2] = a[6] ^ b[6] ^ carry_chain_high_1[2];
    assign carry_chain_high_1[3] = (a[6] & b[6]) | (carry_chain_high_1[2] & (a[6] | b[6]));
    
    assign sum_high_1[3] = a[7] ^ b[7] ^ carry_chain_high_1[3];
    assign carry_high_1 = (a[7] & b[7]) | (carry_chain_high_1[3] & (a[7] | b[7]));

    // Output selection
    assign sum[3:0] = sum_low;
    assign sum[7:4] = carry_low ? sum_high_1 : sum_high_0;
    assign cout = carry_low ? carry_high_1 : carry_high_0;

endmodule