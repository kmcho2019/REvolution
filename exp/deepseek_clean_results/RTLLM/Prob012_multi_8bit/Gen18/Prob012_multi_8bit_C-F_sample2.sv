module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Early termination detection
    wire [7:0] B_mask;
    assign B_mask[0] = |B[7:0];
    assign B_mask[1] = |B[7:1];
    assign B_mask[2] = |B[7:2];
    assign B_mask[3] = |B[7:3];
    assign B_mask[4] = |B[7:4];
    assign B_mask[5] = |B[7:5];
    assign B_mask[6] = |B[7:6];
    assign B_mask[7] = B[7];

    // Conditional partial product generation with shift-mask optimization
    wire [15:0] pp [7:0];
    assign pp[0] = B_mask[0] ? { {8{1'b0}}, A & {8{B[0]}} } : 16'b0;
    assign pp[1] = B_mask[1] ? { {7{1'b0}}, A & {8{B[1]}}, 1'b0 } : 16'b0;
    assign pp[2] = B_mask[2] ? { {6{1'b0}}, A & {8{B[2]}}, 2'b0 } : 16'b0;
    assign pp[3] = B_mask[3] ? { {5{1'b0}}, A & {8{B[3]}}, 3'b0 } : 16'b0;
    assign pp[4] = B_mask[4] ? { {4{1'b0}}, A & {8{B[4]}}, 4'b0 } : 16'b0;
    assign pp[5] = B_mask[5] ? { {3{1'b0}}, A & {8{B[5]}}, 5'b0 } : 16'b0;
    assign pp[6] = B_mask[6] ? { {2{1'b0}}, A & {8{B[6]}}, 6'b0 } : 16'b0;
    assign pp[7] = B_mask[7] ? { {1{1'b0}}, A & {8{B[7]}}, 7'b0 } : 16'b0;

    // Balanced CSA reduction tree
    // Level 1: Process 4 pairs of partial products
    wire [15:0] sum1_0, carry1_0;
    wire [15:0] sum1_1, carry1_1;
    csa csa_level1_0 (pp[0], pp[1], pp[2], sum1_0, carry1_0);
    csa csa_level1_1 (pp[3], pp[4], pp[5], sum1_1, carry1_1);
    
    // Level 2: Process remaining terms and level 1 results
    wire [15:0] sum2_0, carry2_0;
    wire [15:0] sum2_1, carry2_1;
    csa csa_level2_0 (sum1_0, {carry1_0[14:0], 1'b0}, sum1_1, sum2_0, carry2_0);
    csa csa_level2_1 ({carry1_1[14:0], 1'b0}, pp[6], pp[7], sum2_1, carry2_1);
    
    // Level 3: Final reduction
    wire [15:0] sum3, carry3;
    csa csa_level3 (sum2_0, {carry2_0[14:0], 1'b0}, sum2_1, sum3, carry3);
    
    // Final addition with hybrid CLA
    wire [15:0] final_carry = {carry3[14:0], 1'b0} + {carry2_1[14:0], 1'b0};
    hybrid_adder final_adder (
        .a(sum3),
        .b(final_carry),
        .sum(product)
    );

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

// Hybrid 16-bit adder (4-bit CLA blocks with ripple between)
module hybrid_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [16:0] carry;
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 4) begin : adder_block
            // 4-bit CLA
            wire [3:0] p = a[i+:4] ^ b[i+:4];
            wire [3:0] g = a[i+:4] & b[i+:4];
            
            wire [4:1] block_carry;
            assign block_carry[1] = g[0] | (p[0] & carry[i]);
            assign block_carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[i]);
            assign block_carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                                  (p[2] & p[1] & p[0] & carry[i]);
            assign block_carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                                  (p[3] & p[2] & p[1] & g[0]) | 
                                  (p[3] & p[2] & p[1] & p[0] & carry[i]);
            
            assign sum[i+0] = p[0] ^ carry[i];
            assign sum[i+1] = p[1] ^ block_carry[1];
            assign sum[i+2] = p[2] ^ block_carry[2];
            assign sum[i+3] = p[3] ^ block_carry[3];
            
            assign carry[i+4] = block_carry[4];
        end
    endgenerate
endmodule