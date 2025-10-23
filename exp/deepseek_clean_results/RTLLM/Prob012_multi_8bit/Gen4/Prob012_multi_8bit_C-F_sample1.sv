module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products with zero suppression
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level CSA reduction (4:2 compressor)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    csa_16bit csa_level1_0 (
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .sum(sum1),
        .carry(carry1)
    );
    
    csa_16bit csa_level1_1 (
        .a(pp[3]),
        .b(pp[4]),
        .c(pp[5]),
        .sum(sum2),
        .carry(carry2)
    );

    // Second level CSA reduction
    wire [15:0] sum3, carry3;
    csa_16bit csa_level2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition with carry-select optimization
    wire [15:0] final_terms = pp[6] + pp[7];
    wire [15:0] carry_terms = {carry2[14:0], 1'b0} + {carry3[14:0], 1'b0};
    
    // Carry-select final adder
    wire [15:0] sum_low = sum3 + final_terms;
    wire [15:0] sum_high = sum3 + final_terms + 16'b1;
    
    assign product = (carry_terms == 16'b0) ? sum_low : 
                    (sum_low[15] ? sum_high : sum_low);

endmodule

// Optimized 16-bit Carry-Save Adder module
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    // Bitwise CSA implementation
    assign sum = a ^ b ^ c;
    assign carry = {(a[14:0] & b[14:0]) | (a[14:0] & c[14:0]) | (b[14:0] & c[14:0]), 1'b0};
endmodule