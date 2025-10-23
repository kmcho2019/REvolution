module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Efficient conditional partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'b0;
        end
    endgenerate

    // First level: 4:2 compressor for initial reduction (4 PPs)
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second level: 3:2 CSA for next reduction (3 terms)
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[4]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third level: Combine remaining terms
    wire [15:0] sum3, carry3;
    csa_16bit stage3 (
        .a(sum2),
        .b({carry2[14:0], 1'b0}),
        .c(pp[5]),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition with optimized CLA
    wire [15:0] final_op = pp[6] + pp[7] + {carry3[14:0], 1'b0};
    optimized_cla final_adder (
        .a(sum3),
        .b(final_op),
        .sum(product)
    );

endmodule

// Enhanced 4:2 compressor with operand isolation
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    // Operand isolation for stable inputs
    wire [15:0] active_in0 = |in0 ? in0 : 16'b0;
    wire [15:0] active_in1 = |in1 ? in1 : 16'b0;
    wire [15:0] active_in2 = |in2 ? in2 : 16'b0;
    wire [15:0] active_in3 = |in3 ? in3 : 16'b0;
    
    // First compression level
    wire [15:0] s1 = active_in0 ^ active_in1 ^ active_in2;
    wire [15:0] c1 = (active_in0 & active_in1) | 
                     (active_in0 & active_in2) | 
                     (active_in1 & active_in2);
    
    // Second compression level
    assign sum = s1 ^ active_in3 ^ {c1[14:0], 1'b0};
    assign carry = (s1 & active_in3) | 
                  (s1 & {c1[14:0], 1'b0}) | 
                  (active_in3 & {c1[14:0], 1'b0});
endmodule

// Optimized 16-bit CSA with bit-width awareness
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    // Only process active bits to save power
    wire [15:0] active_a = |a ? a : 16'b0;
    wire [15:0] active_b = |b ? b : 16'b0;
    wire [15:0] active_c = |c ? c : 16'b0;
    
    assign sum = active_a ^ active_b ^ active_c;
    assign carry = (active_a & active_b) | 
                  (active_a & active_c) | 
                  (active_b & active_c);
endmodule

// Enhanced 16-bit CLA with grouped lookahead
module optimized_cla(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    wire [16:0] c;
    
    assign c[0] = 1'b0;
    
    // 4-bit grouped lookahead
    genvar i;
    generate
        for (i=0; i<16; i=i+4) begin : cla_group
            // Group propagate
            wire Pg = &p[i+:4];
            // Group generate
            wire Gg = g[i+3] | 
                     (p[i+3] & g[i+2]) | 
                     (p[i+3] & p[i+2] & g[i+1]) | 
                     (p[i+3] & p[i+2] & p[i+1] & g[i]);
            
            if (i == 0) begin
                assign c[1] = g[0] | (p[0] & c[0]);
                assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
                assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                             (p[2] & p[1] & p[0] & c[0]);
                assign c[4] = Gg | (Pg & c[0]);
            end else begin
                assign c[i+1] = g[i] | (p[i] & c[i]);
                assign c[i+2] = g[i+1] | (p[i+1] & g[i]) | (p[i+1] & p[i] & c[i]);
                assign c[i+3] = g[i+2] | (p[i+2] & g[i+1]) | 
                               (p[i+2] & p[i+1] & g[i]) | 
                               (p[i+2] & p[i+1] & p[i] & c[i]);
                assign c[i+4] = Gg | (Pg & c[i]);
            end
        end
    endgenerate
    
    assign sum = p ^ c[15:0];
endmodule