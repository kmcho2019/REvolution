module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products conditionally
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level CSA reduction: process 6 partial products in parallel
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    wire [15:0] sum1_2, carry1_2;
    
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1_0, carry1_0);
    csa csa_level1_1 (pp[3], pp[4], pp[5], sum1_1, carry1_1);
    assign sum1_2 = pp[6];  // Remaining terms
    assign carry1_2 = pp[7];

    // Second level CSA reduction
    wire [15:0] sum2, carry2;
    wire [15:0] sum2_1, carry2_1;
    
    csa csa_level2_0 (sum1_0, {carry1_0[14:0], 1'b0}, sum1_1, sum2, carry2);
    csa csa_level2_1 ({carry1_1[14:0], 1'b0}, sum1_2, {carry1_2[14:0], 1'b0}, sum2_1, carry2_1);

    // Final addition with ripple-carry adder
    wire [15:0] final_sum, final_carry;
    assign final_sum = sum2 + sum2_1;
    assign final_carry = {carry2[14:0], 1'b0} + {carry2_1[14:0], 1'b0};
    
    assign product = final_sum + final_carry;

endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule