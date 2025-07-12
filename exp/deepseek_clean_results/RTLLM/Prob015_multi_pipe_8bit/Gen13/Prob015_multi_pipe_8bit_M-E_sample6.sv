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
    reg [15:0] sum1, carry1;
    reg [15:0] sum2, carry2;
    reg [15:0] result_reg;
    reg [3:0] en_pipeline;

    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    pp[i] <= 16'b0;
                end else if (en_pipeline[0]) begin
                    pp[i] <= (b_reg[i] ? {8'b0, a_reg} << i : 16'b0);
                end
            end
        end
    endgenerate

    // Wallace Tree Stage 1: First level of 3:2 compression
    wire [15:0] s1_0, c1_0, s1_1, c1_1, s1_2, c1_2;
    compressor_3to2 c0 (pp[0], pp[1], pp[2], s1_0, c1_0);
    compressor_3to2 c1 (pp[3], pp[4], pp[5], s1_1, c1_1);
    compressor_3to2 c2 (pp[6], pp[7], 16'b0, s1_2, c1_2);

    // Wallace Tree Stage 2: Second level of compression
    wire [15:0] s2_0, c2_0;
    compressor_3to2 c3 (s1_0, {c1_0[14:0], 1'b0}, s1_1, s2_0, c2_0);
    wire [15:0] s2_1 = s1_2;
    wire [15:0] c2_1 = {c1_1[14:0], 1'b0};

    // Final addition
    wire [15:0] stage3_sum = s2_0 + {c2_0[14:0], 1'b0} + s2_1 + {c2_1[14:0], 1'b0};

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum1 <= 16'b0;
            carry1 <= 16'b0;
            sum2 <= 16'b0;
            carry2 <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 4'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 2: Register first compression results
            sum1 <= {s1_0, s1_1, s1_2};
            carry1 <= {c1_0, c1_1, c1_2};

            // Stage 3: Register second compression results
            sum2 <= {s2_0, s2_1};
            carry2 <= {c2_0, c2_1};

            // Stage 4: Register final result
            result_reg <= stage3_sum;

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg : 16'b0;

endmodule

// 3:2 compressor module (full adder)
module compressor_3to2 (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    output wire [15:0] sum,
    output wire [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule