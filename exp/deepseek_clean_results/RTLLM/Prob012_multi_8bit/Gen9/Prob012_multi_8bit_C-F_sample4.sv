module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products conditionally
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level CSA reduction (process 4 partial products in parallel)
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1_0, carry1_0);
    csa csa_level1_1 (pp[3], pp[4], pp[5], sum1_1, carry1_1);

    // Second level CSA reduction
    wire [15:0] sum2, carry2;
    csa csa_level2 (sum1_0, {carry1_0[14:0], 1'b0}, sum1_1, sum2, carry2);

    // Third level combines remaining terms
    wire [15:0] sum3, carry3;
    csa csa_level3 (sum2, {carry2[14:0], 1'b0}, {carry1_1[14:0], 1'b0}, sum3, carry3);

    // Final addition with CLA adder
    wire [15:0] final_sum;
    cla_adder final_adder (
        .a(sum3),
        .b({carry3[14:0], 1'b0} + pp[6] + pp[7]),
        .sum(product)
    );

endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// 16-bit Carry-Lookahead Adder
module cla_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder
            wire p = a[i] ^ b[i];
            wire g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
    endgenerate
endmodule