module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products conditionally with power optimization
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level Wallace reduction with 4:2 compressors
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    compressor_4to2 stage1_0 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );
    
    compressor_4to2 stage1_1 (
        .in0(pp[4]),
        .in1(pp[5]),
        .in2(pp[6]),
        .in3(pp[7]),
        .sum(sum2),
        .carry(carry2)
    );

    // Second level Wallace reduction (3:2 CSA)
    wire [15:0] sum3, carry3;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Third level combines remaining terms
    wire [15:0] sum4 = {carry2[14:0], 1'b0};
    wire [15:0] carry4 = 16'b0; // No carry from last term

    // Final addition with optimized hybrid adder
    wire [15:0] final_sum = sum3 + sum4;
    wire [15:0] final_carry = {carry3[14:0], 1'b0} + carry4;
    
    optimized_hybrid_adder final_adder (
        .a(final_sum),
        .b(final_carry),
        .sum(product)
    );

endmodule

// Optimized 4:2 compressor (better than two CSAs)
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = in0 ^ in1 ^ in2;
    wire [15:0] c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    assign sum = s1 ^ in3 ^ {c1[14:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[14:0], 1'b0}) | (in3 & {c1[14:0], 1'b0});
endmodule

// Optimized hybrid adder with grouped CLA
module optimized_hybrid_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Grouped CLA structure (4-bit blocks)
    wire [3:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2;
    
    cla_4bit block0 (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(sum0), .cout(cout0));
    cla_4bit block1 (.a(a[7:4]), .b(b[7:4]), .cin(cout0), .sum(sum1), .cout(cout1));
    cla_4bit block2 (.a(a[11:8]), .b(b[11:8]), .cin(cout1), .sum(sum2), .cout(cout2));
    cla_4bit block3 (.a(a[15:12]), .b(b[15:12]), .cin(cout2), .sum(sum3));
    
    assign sum = {sum3, sum2, sum1, sum0};
endmodule

// Optimized 4-bit CLA block
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    wire [3:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    
    assign sum = p ^ c;
    assign cout = g[3] | (p[3] & c[3]);
endmodule

// 16-bit Carry Save Adder (optimized)
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c) << 1;
endmodule