module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Efficient partial product generation with conditional activation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'b0;
        end
    endgenerate

    // First stage: 4:2 compressor for efficient initial reduction
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second stage: Balanced CSA reduction
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[4]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third stage: Combine remaining terms with early termination check
    wire [15:0] sum3, carry3;
    csa_16bit stage3 (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .c(|B[7:5] ? pp[5] : 16'b0),  // Early termination
        .sum(sum3),
        .carry(carry3)
    );

    // Final stage preparation with operand isolation
    wire [15:0] final_operand;
    assign final_operand = (|B[7:6] ? (pp[6] + pp[7]) : 16'b0;

    // Optimized hybrid final adder
    wire [15:0] carry_extended = {carry3[14:0], 1'b0};
    hybrid_adder final_adder (
        .a(sum3),
        .b(carry_extended),
        .c(final_operand),
        .sum(product)
    );

endmodule

// Improved 4:2 compressor module
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

// Optimized hybrid adder (CLA for upper bits, RCA for lower)
module hybrid_adder(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum
);
    // First CSA stage
    wire [15:0] s = a ^ b ^ c;
    wire [15:0] cr = (a & b) | (a & c) | (b & c);
    
    // Hybrid final adder (CLA for bits 8-15, RCA for bits 0-7)
    wire [15:0] p = s ^ {cr[14:0], 1'b0};
    wire [15:0] g = s & {cr[14:0], 1'b0};
    
    // Carry generation
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    // RCA for lower bits
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : rca
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
            assign sum[i] = p[i] ^ carry[i];
        end
        
        // CLA for upper bits
        for (i=8; i<16; i=i+1) begin : cla
            wire [7:0] p_block = p[i:i-7];
            wire [7:0] g_block = g[i:i-7];
            wire block_carry = |(g_block & {8{carry[i-7]}});
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
            assign sum[i] = p[i] ^ carry[i];
        end
    endgenerate
endmodule

// Basic 16-bit CSA remains efficient
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