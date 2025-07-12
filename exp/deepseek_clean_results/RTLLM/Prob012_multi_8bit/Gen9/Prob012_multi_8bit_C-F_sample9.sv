module multi_8bit #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    output [2*WIDTH-1:0] product
);

    // Generate partial products with conditional masking
    wire [2*WIDTH-1:0] pp [WIDTH-1:0];
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({{(WIDTH){1'b0}}, A} << i) : {(2*WIDTH){1'b0}};
        end
    endgenerate

    // First stage: Wallace tree reduction (4:2 compression)
    wire [2*WIDTH-1:0] stage1_sum, stage1_carry;
    compressor_4to2 #(2*WIDTH) stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(stage1_sum),
        .carry(stage1_carry)
    );

    // Second stage: Wallace tree reduction (3:2 CSA)
    wire [2*WIDTH-1:0] stage2_sum, stage2_carry;
    csa #(2*WIDTH) stage2 (
        .a(stage1_sum),
        .b({stage1_carry[2*WIDTH-2:0], 1'b0}),
        .c(pp[4]),
        .sum(stage2_sum),
        .carry(stage2_carry)
    );

    // Third stage: Combine remaining terms
    wire [2*WIDTH-1:0] stage3_sum, stage3_carry;
    csa #(2*WIDTH) stage3 (
        .a(stage2_sum),
        .b({stage2_carry[2*WIDTH-2:0], 1'b0}),
        .c(pp[5]),
        .sum(stage3_sum),
        .carry(stage3_carry)
    );

    // Final addition with optimized CLA
    wire [2*WIDTH-1:0] final_operand = pp[6] + pp[7] + {stage3_carry[2*WIDTH-2:0], 1'b0};
    cla #(2*WIDTH) final_adder (
        .a(stage3_sum),
        .b(final_operand),
        .sum(product)
    );

endmodule

// Parameterized 4:2 compressor
module compressor_4to2 #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);
    wire [WIDTH-1:0] s1, c1;
    
    // First level compression
    assign s1 = in0 ^ in1 ^ in2;
    assign c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    // Second level compression
    assign sum = s1 ^ in3 ^ {c1[WIDTH-2:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[WIDTH-2:0], 1'b0}) | (in3 & {c1[WIDTH-2:0], 1'b0});
endmodule

// Parameterized Carry-Save Adder (CSA)
module csa #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule

// Parameterized Carry-Lookahead Adder (CLA)
module cla #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] g = a & b;
    wire [WIDTH-1:0] p = a ^ b;
    wire [WIDTH:0] c;
    
    assign c[0] = 1'b0;
    
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+1) begin : cla_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate
    
    assign sum = p ^ c[WIDTH-1:0];
endmodule