module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Power-optimized partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level: Balanced 4:2 reduction (Wallace tree)
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    csa csa_level1_0 (.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(sum1_0), .carry(carry1_0));
    csa csa_level1_1 (.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(sum1_1), .carry(carry1_1));

    // Second level: 3:2 reduction
    wire [15:0] sum2, carry2;
    wire [15:0] shifted_carry1_0 = {carry1_0[14:0], 1'b0};
    csa csa_level2 (.a(sum1_0), .b(shifted_carry1_0), .c(sum1_1), .sum(sum2), .carry(carry2));

    // Third level: Combine remaining terms
    wire [15:0] sum3, carry3;
    wire [15:0] shifted_carry1_1 = {carry1_1[14:0], 1'b0};
    wire [15:0] shifted_carry2 = {carry2[14:0], 1'b0};
    csa csa_level3 (.a(sum2), .b(shifted_carry2), .c(shifted_carry1_1 + pp[6] + pp[7]), .sum(sum3), .carry(carry3));

    // Final hybrid adder (CLA upper, RCA lower)
    wire [15:0] final_carry = {carry3[14:0], 1'b0};
    hybrid_adder final_adder (
        .a(sum3),
        .b(final_carry),
        .sum(product)
    );

endmodule

// Optimized Carry-Save Adder
module csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// Hybrid 16-bit adder (CLA upper 8, RCA lower 8)
module hybrid_adder(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower 8 bits - Ripple Carry
    wire [7:0] sum_lo;
    wire cout_lo;
    rca_8bit lo_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_lo),
        .cout(cout_lo)
    );

    // Upper 8 bits - Carry Lookahead
    wire [7:0] sum_hi;
    cla_8bit hi_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(cout_lo),
        .sum(sum_hi)
    );

    assign sum = {sum_hi, sum_lo};
endmodule

// 8-bit Ripple Carry Adder
module rca_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] c = {1'b0, a} + {1'b0, b} + {8'b0, cin};
    assign sum = c[7:0];
    assign cout = c[8];
endmodule

// 8-bit Carry Lookahead Adder
module cla_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum
);
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    wire [8:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);
    
    assign sum = p ^ c[7:0];
endmodule