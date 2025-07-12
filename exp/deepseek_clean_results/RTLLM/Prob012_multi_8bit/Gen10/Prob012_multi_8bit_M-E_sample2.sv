module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products
    wire [15:0] pp[7:0];
    assign pp[0] = B[0] ? {8'b0, A}       : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level of CSA (8 -> 6)
    wire [15:0] sum1, carry1;
    csa_4to2 csa1_0 (pp[0], pp[1], pp[2], pp[3], sum1[15:0], carry1[15:0]);
    wire [15:0] sum2, carry2;
    csa_4to2 csa1_1 (pp[4], pp[5], pp[6], pp[7], sum2[15:0], carry2[15:0]);

    // Second level of CSA (6 -> 4)
    wire [15:0] sum3, carry3;
    csa_3to2 csa2_0 (sum1, carry1, sum2, sum3[15:0], carry3[15:0]);
    wire [15:0] sum4 = carry2;

    // Third level of CSA (4 -> 3)
    wire [15:0] sum5, carry5;
    csa_3to2 csa3_0 (sum3, carry3, sum4, sum5[15:0], carry5[15:0]);

    // Final CPA addition
    assign product = sum5 + (carry5 << 1);

endmodule

// 4:2 Carry Save Adder (compresses 4 inputs to 2)
module csa_4to2 (
    input [15:0] a, b, c, d,
    output [15:0] sum, carry
);
    wire [15:0] s1, c1, s2, c2;
    
    // First level of 3:2 compression
    assign s1 = a ^ b ^ c;
    assign c1 = (a & b) | (a & c) | (b & c);
    
    // Second level with previous carry
    assign sum = s1 ^ d ^ {c1[14:0], 1'b0};
    assign carry = (s1 & d) | (s1 & {c1[14:0], 1'b0}) | (d & {c1[14:0], 1'b0});
endmodule

// 3:2 Carry Save Adder (standard full adder array)
module csa_3to2 (
    input [15:0] a, b, c,
    output [15:0] sum, carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule