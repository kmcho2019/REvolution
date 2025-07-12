module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Conditional partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'b0;
        end
    endgenerate

    // First stage: 4:2 compressor for first 4 partial products
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second stage: Balanced CSA tree
    wire [15:0] sum2, carry2;
    wire [15:0] sum3, carry3;
    
    // Upper CSA (processes pp[4], pp[5] and carry1)
    csa_16bit csa_upper (
        .a(pp[4]),
        .b(pp[5]),
        .c({carry1[14:0], 1'b0}),
        .sum(sum2),
        .carry(carry2)
    );
    
    // Lower CSA (processes pp[6], pp[7] and sum1)
    csa_16bit csa_lower (
        .a(pp[6]),
        .b(pp[7]),
        .c(sum1),
        .sum(sum3),
        .carry(carry3)
    );

    // Final stage: Combine CSA outputs
    wire [15:0] final_sum, final_carry;
    csa_16bit csa_final (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .c(sum3),
        .sum(final_sum),
        .carry(final_carry)
    );

    // Final addition with optimized CLA
    wire [15:0] final_operand = {carry3[14:0], 1'b0} + {final_carry[14:0], 1'b0};
    cla_16bit final_adder (
        .a(final_sum),
        .b(final_operand),
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
    // First compression level
    wire [15:0] s1 = in0 ^ in1 ^ in2;
    wire [15:0] c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    // Second compression level
    assign sum = s1 ^ in3 ^ {c1[14:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[14:0], 1'b0}) | (in3 & {c1[14:0], 1'b0});
endmodule

// Optimized 16-bit carry-save adder
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

// Grouped carry-lookahead adder (4-bit blocks)
module cla_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    wire [16:0] c;
    
    assign c[0] = 1'b0;
    
    // Generate grouped carry lookahead (4-bit blocks)
    genvar i;
    generate
        for (i=0; i<16; i=i+4) begin : cla_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
            assign c[i+2] = g[i+1] | (p[i+1] & g[i]) | (p[i+1] & p[i] & c[i]);
            assign c[i+3] = g[i+2] | (p[i+2] & g[i+1]) | (p[i+2] & p[i+1] & g[i]) | 
                           (p[i+2] & p[i+1] & p[i] & c[i]);
            assign c[i+4] = g[i+3] | (p[i+3] & g[i+2]) | (p[i+3] & p[i+2] & g[i+1]) |
                           (p[i+3] & p[i+2] & p[i+1] & g[i]) | 
                           (p[i+3] & p[i+2] & p[i+1] & p[i] & c[i]);
        end
    endgenerate
    
    assign sum = p ^ c[15:0];
endmodule