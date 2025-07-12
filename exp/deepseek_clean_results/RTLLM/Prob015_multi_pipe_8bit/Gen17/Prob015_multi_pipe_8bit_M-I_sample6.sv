module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers with enable control
    reg [7:0] a_reg, b_reg;
    reg [15:0] sum0_reg, sum1_reg;
    reg [15:0] result_reg;
    reg [2:0] en_pipeline;

    // Generate partial products more efficiently
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Stage 1 sums (4 partial products each)
    wire [15:0] stage1_sum0 = pp[0] + pp[1];
    wire [15:0] stage1_sum1 = pp[2] + pp[3];
    wire [15:0] stage1_sum2 = pp[4] + pp[5];
    wire [15:0] stage1_sum3 = pp[6] + pp[7];

    // Stage 2 sums (2 intermediate sums each)
    wire [15:0] stage2_sum0 = stage1_sum0 + stage1_sum1;
    wire [15:0] stage2_sum1 = stage1_sum2 + stage1_sum3;

    // Pipeline control with enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum0_reg <= 16'b0;
            sum1_reg <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Register inputs and first enable
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: Register intermediate sums
            if (en_pipeline[0]) begin
                sum0_reg <= stage2_sum0;
                sum1_reg <= stage2_sum1;
            end

            // Stage 3: Register final result
            if (en_pipeline[1]) begin
                result_reg <= sum0_reg + sum1_reg;
            end

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule