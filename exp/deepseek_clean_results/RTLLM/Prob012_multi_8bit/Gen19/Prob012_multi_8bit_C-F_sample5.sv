module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products with conditional generation and optimal bit-widths
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A}       : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level: 3:2 compressor reduction (Wallace tree level 1)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    compressor_3to2 level1_0 (.in1(pp[0]), .in2(pp[1]), .in3(pp[2]), .sum(sum1), .carry(carry1));
    compressor_3to2 level1_1 (.in1(pp[3]), .in2(pp[4]), .in3(pp[5]), .sum(sum2), .carry(carry2));

    // Second level: 3:2 compressor reduction (Wallace tree level 2)
    wire [15:0] sum3, carry3;
    wire [15:0] sum4, carry4;
    compressor_3to2 level2_0 (.in1(sum1), .in2(carry1 << 1), .in3(sum2), .sum(sum3), .carry(carry3));
    compressor_3to2 level2_1 (.in1(carry2 << 1), .in2(pp[6]), .in3(pp[7]), .sum(sum4), .carry(carry4));

    // Third level: Final addition preparation
    wire [15:0] final_sum = sum3 + sum4;
    wire [15:0] final_carry = (carry3 << 1) + (carry4 << 1);

    // Final addition with optimized hybrid adder
    hybrid_adder_16bit final_adder (
        .a(final_sum),
        .b(final_carry),
        .sum(product)
    );

endmodule

// Optimized 3:2 compressor (better than basic CSA)
module compressor_3to2(
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = in1 ^ in2 ^ in3;
    assign carry = (in1 & in2) | (in1 & in3) | (in2 & in3);
endmodule

// Optimized 16-bit hybrid adder
module hybrid_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits use optimized ripple carry
    wire [7:0] sum_low;
    wire cout_low;
    rca_8bit_opt low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );

    // Upper 8 bits use carry lookahead
    wire [7:0] sum_high;
    cla_8bit_opt high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_low),
        .sum(sum_high)
    );

    assign sum = {sum_high, sum_low};
endmodule

// Optimized 8-bit ripple carry adder
module rca_8bit_opt(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] carry = {1'b0, a & b} | {1'b0, a & {8{cin}}} | {1'b0, b & {8{cin}}};
    assign sum = a ^ b ^ {8{cin}};
    assign cout = carry[8];
endmodule

// Optimized 8-bit carry lookahead adder
module cla_8bit_opt(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
);
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    wire [7:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    
    assign sum = p ^ c;
endmodule