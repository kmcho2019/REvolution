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
    reg [15:0] pp_matrix [0:7];
    reg [15:0] compressed_1, compressed_2;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Stage 1: Partial product generation
    wire [15:0] pp [0:7];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = {8'b0, (mul_b[i] ? mul_a : 8'b0)} << i;
        end
    endgenerate

    // Stage 2: Wallace Tree compression (first level)
    wire [15:0] stage2_sum, stage2_carry;
    compressor_3to2 compressor1 (
        .a(pp_matrix[0]),
        .b(pp_matrix[1]),
        .c(pp_matrix[2]),
        .sum(stage2_sum),
        .carry(stage2_carry)
    );

    wire [15:0] stage2_sum2, stage2_carry2;
    compressor_3to2 compressor2 (
        .a(pp_matrix[3]),
        .b(pp_matrix[4]),
        .c(pp_matrix[5]),
        .sum(stage2_sum2),
        .carry(stage2_carry2)
    );

    // Stage 3: Final addition
    wire [15:0] final_sum = compressed_1 + compressed_2 + pp_matrix[6] + pp_matrix[7];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (integer j = 0; j < 8; j = j + 1) begin
                pp_matrix[j] <= 16'b0;
            end
            compressed_1 <= 16'b0;
            compressed_2 <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Register inputs and partial products
            a_reg <= mul_a;
            b_reg <= mul_b;
            for (integer j = 0; j < 8; j = j + 1) begin
                pp_matrix[j] <= pp[j];
            end

            // Stage 2: Register compressed values
            compressed_1 <= stage2_sum + (stage2_carry << 1);
            compressed_2 <= stage2_sum2 + (stage2_carry2 << 1);

            // Stage 3: Register final result
            result_reg <= final_sum;

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule

// 3:2 Compressor module (carry-save adder)
module compressor_3to2 (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    output wire [15:0] sum,
    output wire [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule