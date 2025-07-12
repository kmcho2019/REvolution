module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products more efficiently
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i][15:0] = {{8{1'b0}}, (A & {8{B[i]}})} << i;
        end
    endgenerate

    // First stage: 4:2 compressor reduction
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second stage: 3:2 CSA reduction
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[4]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third stage: Combine remaining terms
    wire [15:0] sum3, carry3;
    csa_16bit stage3 (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .c(pp[5]),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition with carry-lookahead adder
    wire [15:0] final_operand = pp[6] + pp[7] + {carry3[14:0], 1'b0};
    cla_16bit final_adder (
        .a(sum3),
        .b(final_operand),
        .sum(product)
    );

endmodule

// 4:2 compressor module (more efficient than two CSAs)
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1, c1, s2, c2;
    
    // First level of compression
    assign s1 = in0 ^ in1 ^ in2;
    assign c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    // Second level of compression
    assign sum = s1 ^ in3 ^ {c1[14:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[14:0], 1'b0}) | (in3 & {c1[14:0], 1'b0});
endmodule

// Optimized 16-bit carry-lookahead adder
module cla_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    wire [15:0] c;
    
    assign c[0] = 1'b0;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    
    genvar i;
    generate
        for (i=4; i<16; i=i+1) begin : cla_gen
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate
    
    assign sum = p ^ c;
endmodule

// Basic 16-bit CSA remains the same
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule