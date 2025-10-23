module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate partial products using bitwise AND
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = {{8{B[i]}} & A, {8{1'b0}}} << i;
        end
    endgenerate

    // First level CSA reduction (Wallace tree structure)
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1_0, carry1_0);
    csa csa_level1_1 (pp[3], pp[4], pp[5], sum1_1, carry1_1);

    // Second level CSA reduction
    wire [15:0] sum2, carry2;
    csa csa_level2 (sum1_0, carry1_0, sum1_1, sum2, carry2);

    // Third level combines remaining terms
    wire [15:0] sum3, carry3;
    csa csa_level3 (sum2, carry2, carry1_1, sum3, carry3);

    // Final addition with optimized ripple-carry adder
    wire [15:0] final_carry = {carry3[14:0], 1'b0};
    wire [15:0] final_pp = pp[6] + pp[7];
    assign product = sum3 + final_carry + final_pp;

endmodule

// Optimized Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a | b) & (a | c) & (b | c)) << 1;
endmodule