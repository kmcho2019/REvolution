module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Stage 1: Generate partial products with conditional shifts
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // Stage 2: First level Wallace reduction (4:2 compressors)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    csa_16bit csa_level1_0 (.a(pp[0]), .b(pp[1]), .c(pp[2]), .sum(sum1), .carry(carry1));
    csa_16bit csa_level1_1 (.a(pp[3]), .b(pp[4]), .c(pp[5]), .sum(sum2), .carry(carry2));

    // Stage 3: Second level binary reduction
    wire [15:0] sum3, carry3;
    wire [15:0] sum4, carry4;
    csa_16bit csa_level2_0 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );
    
    csa_16bit csa_level2_1 (
        .a({carry2[14:0], 1'b0}),
        .b(pp[6]),
        .c(pp[7]),
        .sum(sum4),
        .carry(carry4)
    );

    // Stage 4: Final addition with carry-select
    wire [15:0] final_a = sum3 + sum4;
    wire [15:0] final_b = {carry3[14:0], 1'b0} + {carry4[14:0], 1'b0};
    
    carry_select_16bit final_adder (
        .a(final_a),
        .b(final_b),
        .sum(product)
    );

endmodule

// Optimized 16-bit carry-select adder
module carry_select_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Split into 4-bit blocks
    wire [3:0] sum0, sum1_c0, sum1_c1;
    wire [3:0] sum2_c0, sum2_c1;
    wire [3:0] sum3_c0, sum3_c1;
    
    // Block 0 (LSB) - always ripple
    rca_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum0),
        .cout(cout0)
    );
    
    // Block 1 - select between carry=0/1
    rca_4bit block1_c0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum1_c0)
    );
    rca_4bit block1_c1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1_c1)
    );
    wire [3:0] sum1 = cout0 ? sum1_c1 : sum1_c0;
    wire cout1 = cout0 ? (|sum1_c1) : (|sum1_c0);
    
    // Block 2 - select between carry=0/1
    rca_4bit block2_c0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum2_c0)
    );
    rca_4bit block2_c1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum2_c1)
    );
    wire [3:0] sum2 = cout1 ? sum2_c1 : sum2_c0;
    wire cout2 = cout1 ? (|sum2_c1) : (|sum2_c0);
    
    // Block 3 (MSB) - select between carry=0/1
    rca_4bit block3_c0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum3_c0)
    );
    rca_4bit block3_c1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum3_c1)
    );
    wire [3:0] sum3 = cout2 ? sum3_c1 : sum3_c0;
    
    assign sum = {sum3, sum2, sum1, sum0};
endmodule

// 4-bit ripple carry adder
module rca_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] c;
    assign c[0] = cin;
    
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);
    
    assign sum[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
    
    assign sum[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
    
    assign sum[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
    
    assign cout = c[4];
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