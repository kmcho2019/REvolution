module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // First 4-bit block (computes both possible sums)
    wire [3:0] sum0_0, sum0_1;
    wire carry0_0, carry0_1;
    
    // Sum assuming carry-in = 0
    assign sum0_0[0] = a[0] ^ b[0];
    assign sum0_0[1] = a[1] ^ b[1] ^ (a[0] & b[0]);
    assign sum0_0[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0]));
    assign sum0_0[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0])));
    assign carry0_0 = a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0])));
    
    // Sum assuming carry-in = 1
    assign sum0_1[0] = ~(a[0] ^ b[0]);
    assign sum0_1[1] = a[1] ^ b[1] ^ (a[0] | b[0]);
    assign sum0_1[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] | b[1]) & (a[0] | b[0]));
    assign sum0_1[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] | b[0])));
    assign carry0_1 = a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] | b[0])));
    
    // Select first 4-bit result based on actual carry-in
    wire [3:0] sum0;
    wire carry0;
    assign sum0 = cin ? sum0_1 : sum0_0;
    assign carry0 = cin ? carry0_1 : carry0_0;
    
    // Second 4-bit block (same structure as first)
    wire [3:0] sum1_0, sum1_1;
    wire carry1_0, carry1_1;
    
    // Sum assuming carry-in = 0
    assign sum1_0[0] = a[4] ^ b[4];
    assign sum1_0[1] = a[5] ^ b[5] ^ (a[4] & b[4]);
    assign sum1_0[2] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4]));
    assign sum1_0[3] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4])));
    assign carry1_0 = a[7] & b[7] | (a[7] | b[7]) & (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4])));
    
    // Sum assuming carry-in = 1
    assign sum1_1[0] = ~(a[4] ^ b[4]);
    assign sum1_1[1] = a[5] ^ b[5] ^ (a[4] | b[4]);
    assign sum1_1[2] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] | b[5]) & (a[4] | b[4]));
    assign sum1_1[3] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] | b[4])));
    assign carry1_1 = a[7] & b[7] | (a[7] | b[7]) & (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] | b[4])));
    
    // Select second 4-bit result based on first block's carry-out
    wire [3:0] sum1;
    assign sum1 = carry0 ? sum1_1 : sum1_0;
    assign cout = carry0 ? carry1_1 : carry1_0;
    
    // Combine results
    assign sum = {sum1, sum0};

endmodule