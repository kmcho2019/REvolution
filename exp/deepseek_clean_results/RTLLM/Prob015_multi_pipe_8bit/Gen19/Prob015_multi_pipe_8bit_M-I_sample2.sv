module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers with enable gating
    reg [7:0] a_reg, b_reg;
    reg [11:0] pp_low_reg;  // Reduced width (max value: 255*15 = 3825 < 4096)
    reg [11:0] pp_mid_reg;  // Intermediate sum register
    reg [15:0] result_reg;
    reg [3:0] en_pipeline;  // 4-stage enable pipeline

    // Partial product generation using generate
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Carry-save addition stages
    wire [11:0] sum_low = pp[0][11:0] + pp[1][11:0] + pp[2][11:0];
    wire [11:0] sum_mid = pp[3][11:0] + pp[4][11:0] + pp[5][11:0];
    wire [15:0] sum_high = pp[6] + pp[7];
    wire [15:0] final_sum = {4'b0, pp_low_reg} + {4'b0, pp_mid_reg} + sum_high;

    // Pipeline control with enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_low_reg <= 12'b0;
            pp_mid_reg <= 12'b0;
            result_reg <= 16'b0;
            en_pipeline <= 4'b0;
        end else begin
            // Stage 1: Register inputs only when enabled
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: Register first level sums
            if (en_pipeline[0]) begin
                pp_low_reg <= sum_low;
                pp_mid_reg <= sum_mid;
            end

            // Stage 3: Register final sum
            if (en_pipeline[1]) begin
                result_reg <= final_sum;
            end

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg : 16'b0;

endmodule