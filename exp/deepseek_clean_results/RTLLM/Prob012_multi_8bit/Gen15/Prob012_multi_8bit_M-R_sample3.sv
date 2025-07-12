module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products in parallel
    wire [15:0] pp0 = B[0] ? {8'b0, A} : 16'b0;
    wire [15:0] pp1 = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    wire [15:0] pp2 = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    wire [15:0] pp3 = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    wire [15:0] pp4 = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    wire [15:0] pp5 = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    wire [15:0] pp6 = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    wire [15:0] pp7 = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level of CSA reduction (4 pairs)
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    wire [15:0] sum1_2, carry1_2;
    wire [15:0] sum1_3, carry1_3;
    
    csa csa1_0(pp0, pp1, pp2, sum1_0, carry1_0);
    csa csa1_1(pp3, pp4, pp5, sum1_1, carry1_1);
    csa csa1_2(pp6, pp7, 16'b0, sum1_2, carry1_2);

    // Second level of CSA reduction
    wire [15:0] sum2_0, carry2_0;
    wire [15:0] sum2_1, carry2_1;
    
    csa csa2_0(sum1_0, {carry1_0[14:0], 1'b0}, sum1_1, sum2_0, carry2_0);
    csa csa2_1({carry1_1[14:0], 1'b0}, sum1_2, {carry1_2[14:0], 1'b0}, sum2_1, carry2_1);

    // Third level of CSA reduction
    wire [15:0] sum3, carry3;
    csa csa3(sum2_0, {carry2_0[14:0], 1'b0}, sum2_1, sum3, carry3);

    // Final addition (ripple carry adder)
    wire [15:0] final_carry_in = {carry2_1[14:0], 1'b0} + {carry3[14:0], 1'b0};
    assign product = sum3 + final_carry_in;

endmodule

// Carry-save adder module
module csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule