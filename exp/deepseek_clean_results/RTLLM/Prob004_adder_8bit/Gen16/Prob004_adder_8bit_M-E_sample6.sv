module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Block 0: bits 0-2 (3 bits)
    wire [2:0] sum0;
    wire c0, p0;
    
    // First full adder
    assign sum0[0] = a[0] ^ b[0] ^ cin;
    wire p0_0 = a[0] ^ b[0];
    wire g0_0 = a[0] & b[0];
    wire c0_1 = g0_0 | (p0_0 & cin);
    
    // Second full adder
    assign sum0[1] = a[1] ^ b[1] ^ c0_1;
    wire p0_1 = a[1] ^ b[1];
    wire g0_1 = a[1] & b[1];
    wire c0_2 = g0_1 | (p0_1 & c0_1);
    
    // Third full adder
    assign sum0[2] = a[2] ^ b[2] ^ c0_2;
    wire p0_2 = a[2] ^ b[2];
    wire g0_2 = a[2] & b[2];
    assign c0 = g0_2 | (p0_2 & c0_2);
    assign p0 = p0_0 & p0_1 & p0_2;
    
    assign sum[2:0] = sum0;
    
    // Block 1: bits 3-4 (2 bits)
    wire [1:0] sum1;
    wire c1, p1;
    
    // Carry select for block 1
    wire carry_in_block1 = p0 ? cin : c0;
    
    // First full adder
    assign sum1[0] = a[3] ^ b[3] ^ carry_in_block1;
    wire p1_0 = a[3] ^ b[3];
    wire g1_0 = a[3] & b[3];
    wire c1_1 = g1_0 | (p1_0 & carry_in_block1);
    
    // Second full adder
    assign sum1[1] = a[4] ^ b[4] ^ c1_1;
    wire p1_1 = a[4] ^ b[4];
    wire g1_1 = a[4] & b[4];
    assign c1 = g1_1 | (p1_1 & c1_1);
    assign p1 = p1_0 & p1_1;
    
    assign sum[4:3] = sum1;
    
    // Block 2: bits 5-7 (3 bits)
    wire [2:0] sum2;
    
    // Carry select for block 2
    wire carry_in_block2 = (p0 & p1) ? cin : 
                          (p1 ? c0 : c1);
    
    // First full adder
    assign sum2[0] = a[5] ^ b[5] ^ carry_in_block2;
    wire p2_0 = a[5] ^ b[5];
    wire g2_0 = a[5] & b[5];
    wire c2_1 = g2_0 | (p2_0 & carry_in_block2);
    
    // Second full adder
    assign sum2[1] = a[6] ^ b[6] ^ c2_1;
    wire p2_1 = a[6] ^ b[6];
    wire g2_1 = a[6] & b[6];
    wire c2_2 = g2_1 | (p2_1 & c2_1);
    
    // Third full adder
    assign sum2[2] = a[7] ^ b[7] ^ c2_2;
    wire p2_2 = a[7] ^ b[7];
    wire g2_2 = a[7] & b[7];
    assign cout = g2_2 | (p2_2 & c2_2);
    
    assign sum[7:5] = sum2;

endmodule