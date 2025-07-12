module multi_8bit(
    input clk,
    input rst_n,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Power-gated partial product generation
    wire [7:0] B_gated;
    assign B_gated = rst_n ? B : 8'b0;

    // Compact partial product generation with operand isolation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B_gated[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // First level: 4:2 compressor reduction
    wire [15:0] sum1, carry1, cout1;
    wire [15:0] sum2, carry2, cout2;
    compressor_4to2 comp_level1_0 (
        .a(pp[0]), .b(pp[1]), .c(pp[2]), .d(pp[3]),
        .sum(sum1), .carry(carry1), .cout(cout1)
    );
    compressor_4to2 comp_level1_1 (
        .a(pp[4]), .b(pp[5]), .c(pp[6]), .d(pp[7]),
        .sum(sum2), .carry(carry2), .cout(cout2)
    );

    // Second level: 4:2 compressor reduction
    wire [15:0] sum3, carry3, cout3;
    compressor_4to2 comp_level2 (
        .a(sum1), .b({carry1[14:0], 1'b0}),
        .c(sum2), .d({carry2[14:0], 1'b0}),
        .sum(sum3), .carry(carry3), .cout(cout3)
    );

    // Final addition with Kogge-Stone adder
    wire [15:0] final_sum;
    kogge_stone_16bit final_adder (
        .a(sum3),
        .b({carry3[14:0], 1'b0}),
        .sum(final_sum)
    );

    // Pipeline register for better timing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 16'b0;
        end else begin
            product <= final_sum;
        end
    end

endmodule

// Optimized 4:2 compressor
module compressor_4to2(
    input [15:0] a, b, c, d,
    output [15:0] sum, carry, cout
);
    wire [15:0] s1 = a ^ b ^ c;
    wire [15:0] c1 = (a & b) | (a & c) | (b & c);
    
    assign sum = s1 ^ d;
    assign carry = (s1 & d) | (c1 & ~d);
    assign cout = c1 & d;
endmodule

// High-speed Kogge-Stone adder
module kogge_stone_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Generate and propagate signals
    wire [15:0] g = a & b;
    wire [15:0] p = a ^ b;
    
    // Carry computation stages
    wire [15:0] g1, p1;
    wire [15:0] g2, p2;
    wire [15:0] g3, p3;
    wire [15:0] g4, p4;
    
    // Stage 1
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    genvar i;
    generate
        for (i=1; i<16; i=i+1) begin : stage1
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate
    
    // Stage 2
    assign g2[1:0] = g1[1:0];
    assign p2[1:0] = p1[1:0];
    generate
        for (i=2; i<16; i=i+1) begin : stage2
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    endgenerate
    
    // Stage 3
    assign g3[3:0] = g2[3:0];
    assign p3[3:0] = p2[3:0];
    generate
        for (i=4; i<16; i=i+1) begin : stage3
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            assign p3[i] = p2[i] & p2[i-4];
        end
    endgenerate
    
    // Stage 4
    assign g4[7:0] = g3[7:0];
    assign p4[7:0] = p3[7:0];
    generate
        for (i=8; i<16; i=i+1) begin : stage4
            assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
            assign p4[i] = p3[i] & p3[i-8];
        end
    endgenerate
    
    // Final carry computation
    wire [15:0] carry;
    assign carry[0] = 1'b0;
    generate
        for (i=1; i<16; i=i+1) begin : carry_gen
            assign carry[i] = g4[i-1];
        end
    endgenerate
    
    // Sum computation
    assign sum = p ^ carry;
endmodule