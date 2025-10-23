module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products conditionally with shift
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level Wallace reduction (4:2 compressor)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    csa_16bit csa_level1_0 (.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(sum1), .carry(carry1));
    csa_16bit csa_level1_1 (.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(sum2), .carry(carry2));

    // Second level Wallace reduction (3:2 compressor)
    wire [15:0] sum3, carry3;
    csa_16bit csa_level2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Third level combines remaining terms
    wire [15:0] sum4, carry4;
    csa_16bit csa_level3 (
        .a({carry2[14:0], 1'b0}),
        .b(pp[6]),
        .c(pp[7]),
        .sum(sum4),
        .carry(carry4)
    );

    // Final addition with hybrid adder (CLA upper, RCA lower)
    wire [15:0] final_sum = sum3 + sum4;
    wire [15:0] final_carry = {carry3[14:0], 1'b0} + {carry4[14:0], 1'b0};
    
    hybrid_adder_16bit final_adder (
        .a(final_sum),
        .b(final_carry),
        .sum(product)
    );

endmodule

// Optimized 16-bit hybrid adder (CLA upper 8, RCA lower 8)
module hybrid_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits use ripple carry
    wire [7:0] sum_low;
    wire cout_low;
    rca_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );

    // Upper 8 bits use carry lookahead
    wire [7:0] sum_high;
    cla_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_low),
        .sum(sum_high)
    );

    assign sum = {sum_high, sum_low};
endmodule

// 8-bit ripple carry adder
module rca_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : rca_gen
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[8];
endmodule

// 8-bit carry lookahead adder
module cla_8bit(
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
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    
    genvar i;
    generate
        for (i=4; i<8; i=i+1) begin : cla_gen
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate
    
    assign sum = p ^ c;
endmodule

// 16-bit Carry Save Adder (CSA)
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