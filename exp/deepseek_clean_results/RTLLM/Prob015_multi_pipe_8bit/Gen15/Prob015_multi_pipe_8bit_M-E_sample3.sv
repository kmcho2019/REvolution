module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [0:7];
    reg [15:0] sum_reg, carry_reg;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Generate all partial products
    always @(*) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    end

    // Wallace Tree compression (4:2 compressors)
    wire [15:0] s1_0, c1_0, s1_1, c1_1;
    wire [15:0] s2_0, c2_0, s2_1, c2_1;
    wire [15:0] s3, c3;

    // First level compression
    compressor_4to2 comp1_0 (pp[0], pp[1], pp[2], pp[3], s1_0, c1_0);
    compressor_4to2 comp1_1 (pp[4], pp[5], pp[6], pp[7], s1_1, c1_1);

    // Second level compression
    compressor_4to2 comp2_0 (s1_0, c1_0, s1_1, c1_1, s2_0, c2_0);
    compressor_4to2 comp2_1 (s2_0, c2_0, 16'b0, 16'b0, s2_1, c2_1);

    // Final addition (carry lookahead)
    carry_lookahead_adder cla (
        .a(s2_1),
        .b(c2_1),
        .sum(s3),
        .cout(c3)
    );

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum_reg <= 16'b0;
            carry_reg <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else if (mul_en_in) begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 2: Register compressed sums
            sum_reg <= s2_1;
            carry_reg <= c2_1;

            // Stage 3: Register final result
            result_reg <= s3 + {c3, 15'b0};

            // Enable pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule

// 4:2 compressor module
module compressor_4to2 (
    input [15:0] a, b, c, d,
    output [15:0] sum, carry
);
    wire [15:0] s1 = a ^ b;
    wire [15:0] c1 = a & b;

    wire [15:0] s2 = s1 ^ c;
    wire [15:0] c2 = s1 & c;

    wire [15:0] s3 = s2 ^ d;
    wire [15:0] c3 = s2 & d;

    assign sum = s3;
    assign carry = (c1 | c2) << 1 | c3 << 1;
endmodule

// Carry lookahead adder
module carry_lookahead_adder (
    input [15:0] a, b,
    output [15:0] sum,
    output cout
);
    wire [15:0] g = a & b;
    wire [15:0] p = a | b;
    wire [15:0] c;

    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & g[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    // ... continue for all bits
    assign c[15] = g[15] | (p[15] & g[14]) | ...;

    assign sum = a ^ b ^ c;
    assign cout = c[15];
endmodule