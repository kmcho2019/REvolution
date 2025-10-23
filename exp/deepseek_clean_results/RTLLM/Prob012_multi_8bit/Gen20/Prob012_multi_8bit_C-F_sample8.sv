module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products with early termination
    wire [15:0] pp [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // Level 1 CSA: Reduce 8 to 4
    wire [15:0] sum1 [0:3];
    wire [15:0] carry1 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level1_csa
            csa csa_inst(
                .a(pp[2*i]),
                .b(pp[2*i+1]),
                .c(16'b0),  // Only 2 operands at this level
                .sum(sum1[i]),
                .carry(carry1[i])
            );
        end
    endgenerate

    // Level 2 CSA: Reduce 4 to 2
    wire [15:0] sum2 [0:1];
    wire [15:0] carry2 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level2_csa
            csa csa_inst(
                .a(sum1[2*i]),
                .b({carry1[2*i][14:0], 1'b0}),
                .c(sum1[2*i+1]),
                .sum(sum2[i]),
                .carry(carry2[i])
            );
        end
    endgenerate

    // Final addition with carry-propagate adder
    wire [15:0] final_sum, final_carry;
    csa final_csa(
        .a(sum2[0]),
        .b({carry1[1][14:0], 1'b0}),
        .c(sum2[1]),
        .sum(final_sum),
        .carry(final_carry)
    );

    // Fast 16-bit carry-propagate adder
    assign product = final_sum + ({final_carry[14:0], 1'b0});

endmodule

// Optimized Carry-Save Adder module
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