module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Efficient conditional partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
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

    // Second stage: Wallace tree reduction (3:2 CSA)
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

    // Final addition with carry-select adder
    wire [15:0] final_operand = pp[6] + pp[7] + {carry3[14:0], 1'b0};
    carry_select_adder #(16) final_adder (
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

// Parameterized carry-select adder
module carry_select_adder #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);
    localparam BLOCK_SIZE = 4;
    wire [WIDTH:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+BLOCK_SIZE) begin : adder_block
            wire [BLOCK_SIZE-1:0] sum0, sum1;
            wire [BLOCK_SIZE:0] local_carry;
            
            // Generate sum assuming carry-in=0
            assign sum0 = a[i+:BLOCK_SIZE] + b[i+:BLOCK_SIZE];
            
            // Generate sum assuming carry-in=1
            assign sum1 = a[i+:BLOCK_SIZE] + b[i+:BLOCK_SIZE] + 1;
            
            // Select appropriate sum based on actual carry
            assign sum[i+:BLOCK_SIZE] = carry[i] ? sum1 : sum0;
            assign carry[i+BLOCK_SIZE] = carry[i] ? sum1[BLOCK_SIZE] : sum0[BLOCK_SIZE];
        end
    endgenerate
endmodule

// Optimized 16-bit CSA
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule