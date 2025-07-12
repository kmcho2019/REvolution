module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // First level of CSA reduction
    wire [15:0] sum1, carry1;
    csa_16bit csa1 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );

    wire [15:0] sum2, carry2;
    csa_16bit csa2 (
        .a(pp[3]),
        .b(pp[4]),
        .c(pp[5]),
        .sum(sum2),
        .carry(carry2)
    );

    // Second level of CSA reduction
    wire [15:0] sum3, carry3;
    csa_16bit csa3 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition with carry-propagate adder
    wire [15:0] final_carry_in = {carry2[14:0], 1'b0} + {carry3[14:0], 1'b0};
    assign product = sum3 + final_carry_in + pp[6] + pp[7];

endmodule

// 16-bit Carry-Save Adder module
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