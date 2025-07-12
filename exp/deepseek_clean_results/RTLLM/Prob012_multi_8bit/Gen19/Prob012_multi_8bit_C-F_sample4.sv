module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products efficiently with conditional generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First stage: 4:2 compressor for initial reduction
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second stage: CSA reduction of first stage results with next PPs
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[4]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third stage: Final CSA reduction
    wire [15:0] sum3, carry3;
    csa_16bit stage3 (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .c(pp[5]),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition with optimized CLA adder
    wire [15:0] final_operand = pp[6] + pp[7] + {carry3[14:0], 1'b0};
    cla_16bit_grouped final_adder (
        .a(sum3),
        .b(final_operand),
        .sum(product)
    );

endmodule

// Optimized 4:2 compressor module
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

// Grouped CLA adder (4-bit blocks)
module cla_16bit_grouped(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    // Generate 4-bit CLA blocks
    genvar i;
    generate
        for (i=0; i<16; i=i+4) begin : cla_block
            // Group propagate and generate
            wire [3:0] p = a[i+:4] ^ b[i+:4];
            wire [3:0] g = a[i+:4] & b[i+:4];
            
            // Carry lookahead within block
            assign carry[i+1] = g[0] | (p[0] & carry[i]);
            assign carry[i+2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[i]);
            assign carry[i+3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                               (p[2] & p[1] & p[0] & carry[i]);
            assign carry[i+4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                               (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[i]);
            
            // Sum generation
            assign sum[i+:4] = p ^ carry[i+:4];
        end
    endgenerate
endmodule

// Optimized CSA module
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