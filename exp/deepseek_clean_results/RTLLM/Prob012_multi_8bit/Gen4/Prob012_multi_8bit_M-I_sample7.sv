module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoder (radix-4) to generate 5 partial products
    wire [8:0] pp [4:0];
    wire [8:0] A_ext = {1'b0, A};
    wire [8:0] A_neg = ~A_ext + 1;
    wire [8:0] A_2x = {A_ext[7:0], 1'b0};
    wire [8:0] A_neg2x = ~A_2x + 1;
    
    // Booth encoding logic
    wire [2:0] booth_sel [4:0];
    assign booth_sel[0] = {B[1], B[0], 1'b0};
    assign booth_sel[1] = B[3:1];
    assign booth_sel[2] = B[5:3];
    assign booth_sel[3] = B[7:5];
    assign booth_sel[4] = {B[7], B[7], B[6]};
    
    // Partial product generation with operand isolation
    genvar i;
    generate
        for (i=0; i<5; i=i+1) begin : pp_gen
            assign pp[i] = (booth_sel[i] == 3'b000 || booth_sel[i] == 3'b111) ? 9'b0 :
                          (booth_sel[i] == 3'b001 || booth_sel[i] == 3'b010) ? A_ext :
                          (booth_sel[i] == 3'b011) ? A_2x :
                          (booth_sel[i] == 3'b100) ? A_neg2x :
                          (booth_sel[i] == 3'b101 || booth_sel[i] == 3'b110) ? A_neg : 9'b0;
        end
    endgenerate

    // Wallace tree reduction (3 stages)
    // Stage 1: 5:3 compression
    wire [10:0] s1, c1, s2, c2;
    csa_11bit stage1_0 (
        .a({2'b0, pp[0]}),
        .b({1'b0, pp[1], 1'b0}),
        .c({pp[2], 2'b0}),
        .sum(s1),
        .carry(c1)
    );
    
    csa_11bit stage1_1 (
        .a({1'b0, pp[3], 2'b0}),
        .b({pp[4], 3'b0}),
        .c(11'b0),
        .sum(s2),
        .carry(c2)
    );
    
    // Stage 2: 4:2 compression
    wire [12:0] s3, c3;
    compressor_4to2_13bit stage2 (
        .in0({2'b0, s1}),
        .in1({1'b0, c1, 1'b0}),
        .in2({2'b0, s2}),
        .in3({1'b0, c2, 1'b0}),
        .sum(s3),
        .carry(c3)
    );
    
    // Final addition with hierarchical CLA
    wire [15:0] final_op1 = {s3, 3'b0};
    wire [15:0] final_op2 = {c3, 2'b0};
    hierarchical_cla_16bit final_adder (
        .a(final_op1),
        .b(final_op2),
        .sum(product)
    );

endmodule

// Optimized 11-bit CSA
module csa_11bit(
    input [10:0] a,
    input [10:0] b,
    input [10:0] c,
    output [10:0] sum,
    output [10:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = {(a[9:0] & b[9:0]) | (a[9:0] & c[9:0]) | (b[9:0] & c[9:0]), 1'b0};
endmodule

// 4:2 compressor for 13 bits
module compressor_4to2_13bit(
    input [12:0] in0,
    input [12:0] in1,
    input [12:0] in2,
    input [12:0] in3,
    output [12:0] sum,
    output [12:0] carry
);
    wire [12:0] s1, c1;
    
    // First level compression
    assign s1 = in0 ^ in1 ^ in2;
    assign c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    // Second level compression
    assign sum = s1 ^ in3 ^ {c1[11:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[11:0], 1'b0}) | (in3 & {c1[11:0], 1'b0});
endmodule

// Hierarchical 16-bit CLA (4-bit blocks)
module hierarchical_cla_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    wire [3:0] gg, pg, c;
    
    // Block generate/propagate
    assign gg[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign pg[0] = p[3] & p[2] & p[1] & p[0];
    
    assign gg[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign pg[1] = p[7] & p[6] & p[5] & p[4];
    
    assign gg[2] = g[11] | (p[11] & g[10]) | (p[11] & p[10] & g[9]) | (p[11] & p[10] & p[9] & g[8]);
    assign pg[2] = p[11] & p[10] & p[9] & p[8];
    
    assign gg[3] = g[15] | (p[15] & g[14]) | (p[15] & p[14] & g[13]) | (p[15] & p[14] & p[13] & g[12]);
    assign pg[3] = p[15] & p[14] & p[13] & p[12];
    
    // Block carry computation
    assign c[0] = 1'b0;
    assign c[1] = gg[0] | (pg[0] & c[0]);
    assign c[2] = gg[1] | (pg[1] & gg[0]) | (pg[1] & pg[0] & c[0]);
    assign c[3] = gg[2] | (pg[2] & gg[1]) | (pg[2] & pg[1] & gg[0]) | (pg[2] & pg[1] & pg[0] & c[0]);
    
    // Final sum computation
    assign sum[3:0] = p[3:0] ^ {c[0], (g[0] | (p[0] & c[0])), (g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0])), 
                      (g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]))};
    
    assign sum[7:4] = p[7:4] ^ {gg[0] | (pg[0] & c[0]), 
                      (g[4] | (p[4] & (gg[0] | (pg[0] & c[0])))),
                      (g[5] | (p[5] & g[4]) | (p[5] & p[4] & (gg[0] | (pg[0] & c[0])))),
                      (g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & (gg[0] | (pg[0] & c[0]))))};
    
    assign sum[11:8] = p[11:8] ^ {gg[1] | (pg[1] & c[1]),
                      (g[8] | (p[8] & (gg[1] | (pg[1] & c[1])))),
                      (g[9] | (p[9] & g[8]) | (p[9] & p[8] & (gg[1] | (pg[1] & c[1])))),
                      (g[10] | (p[10] & g[9]) | (p[10] & p[9] & g[8]) | (p[10] & p[9] & p[8] & (gg[1] | (pg[1] & c[1]))))};
    
    assign sum[15:12] = p[15:12] ^ {gg[2] | (pg[2] & c[2]),
                       (g[12] | (p[12] & (gg[2] | (pg[2] & c[2])))),
                       (g[13] | (p[13] & g[12]) | (p[13] & p[12] & (gg[2] | (pg[2] & c[2])))),
                       (g[14] | (p[14] & g[13]) | (p[14] & p[13] & g[12]) | (p[14] & p[13] & p[12] & (gg[2] | (pg[2] & c[2]))))};
endmodule