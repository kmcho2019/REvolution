module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products with conditional shifts
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level: 4:2 compressors in balanced tree
    wire [15:0] sum_l1 [1:0];
    wire [15:0] carry_l1 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : level1
            compressor_4to2 comp (
                .in0(pp[4*i]),
                .in1(pp[4*i+1]),
                .in2(pp[4*i+2]),
                .in3(pp[4*i+3]),
                .sum(sum_l1[i]),
                .carry(carry_l1[i])
            );
        end
    endgenerate

    // Second level: Combine sums with carries
    wire [15:0] sum_l2, carry_l2;
    compressor_4to2 level2 (
        .in0(sum_l1[0]),
        .in1({carry_l1[0][14:0], 1'b0}),
        .in2(sum_l1[1]),
        .in3({carry_l1[1][14:0], 1'b0}),
        .sum(sum_l2),
        .carry(carry_l2)
    );

    // Final addition with optimized CLA
    wire [15:0] final_operand = {carry_l2[14:0], 1'b0};
    cla_16bit_optimized final_adder (
        .a(sum_l2),
        .b(final_operand),
        .sum(product)
    );

endmodule

// Optimized 4:2 compressor with balanced tree support
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = in0 ^ in1;
    wire [15:0] c1 = in0 & in1;
    
    wire [15:0] s2 = s1 ^ in2;
    wire [15:0] c2 = (s1 & in2) | c1;
    
    assign sum = s2 ^ in3;
    assign carry = (s2 & in3) | (c2 << 1);
endmodule

// Optimized CLA with 4-bit grouped lookahead
module cla_16bit_optimized(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    
    // 4-bit group lookahead
    wire [3:0] G, P, C;
    assign G[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign P[0] = p[3] & p[2] & p[1] & p[0];
    
    assign G[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign P[1] = p[7] & p[6] & p[5] & p[4];
    
    assign G[2] = g[11] | (p[11] & g[10]) | (p[11] & p[10] & g[9]) | (p[11] & p[10] & p[9] & g[8]);
    assign P[2] = p[11] & p[10] & p[9] & p[8];
    
    assign G[3] = g[15] | (p[15] & g[14]) | (p[15] & p[14] & g[13]) | (p[15] & p[14] & p[13] & g[12]);
    assign P[3] = p[15] & p[14] & p[13] & p[12];
    
    // Group carry generation
    assign C[0] = 1'b0;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Bit-level carries
    wire [15:0] c;
    assign c[0] = C[0];
    assign c[4] = C[1];
    assign c[8] = C[2];
    assign c[12] = C[3];
    
    // Generate remaining carries within groups
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : carry_gen
            if (i%4 != 0) begin
                assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
            end
        end
    endgenerate
    
    assign sum = p ^ c;
endmodule