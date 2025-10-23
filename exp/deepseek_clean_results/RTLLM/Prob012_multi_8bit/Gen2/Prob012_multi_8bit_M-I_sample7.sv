module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products more efficiently
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = {8'b0, (A & {8{B[i]}})} << i;
        end
    endgenerate

    // First level CSA reduction (4:2 compressor)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // Compress 4 partial products to 2
    csa_16bit csa1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );
    
    csa_16bit csa2 (
        .a(pp[3]),
        .b(pp[4]),
        .c(pp[5]),
        .sum(sum2),
        .carry(carry2)
    );

    // Second level CSA reduction (compress remaining terms)
    wire [15:0] sum3, carry3;
    csa_16bit csa3 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition using carry-lookahead adder
    wire [15:0] final_operand_a = sum3;
    wire [15:0] final_operand_b = {carry2[14:0], 1'b0} + {carry3[14:0], 1'b0} + pp[6] + pp[7];
    
    cla_16bit final_adder (
        .a(final_operand_a),
        .b(final_operand_b),
        .sum(product)
    );

endmodule

// Improved 16-bit Carry-Save Adder
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = {(a[14:0] & b[14:0]) | (a[14:0] & c[14:0]) | (b[14:0] & c[14:0]), 1'b0};
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] c;
    assign c[0] = 1'b0;
    
    genvar j;
    generate
        for (j=0; j<16; j=j+1) begin : cla
            wire p, g;
            assign p = a[j] ^ b[j];
            assign g = a[j] & b[j];
            assign c[j+1] = g | (p & c[j]);
            assign sum[j] = p ^ c[j];
        end
    endgenerate
endmodule