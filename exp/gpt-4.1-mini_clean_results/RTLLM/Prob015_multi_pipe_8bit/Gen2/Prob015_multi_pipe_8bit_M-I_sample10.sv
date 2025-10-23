module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline shift register (4 stages to track data validity)
    reg [4:0] mul_en_pipeline;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial sums at stage 0 (combining partial products selectively)
    // We'll generate 4 partial sums by grouping two multiplier bits each to reduce registers
    reg [15:0] pp_sum0, pp_sum1, pp_sum2, pp_sum3;

    // Pipeline stage 1 registers: sum pairs of pp_sumX
    reg [15:0] sum_stage1_0, sum_stage1_1;

    // Pipeline stage 2 register: final sum before output register
    reg [15:0] mul_out_reg;

    integer i;

    // Pipeline enable signal shifting for valid data tracking
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipeline <= 5'd0;
        else
            mul_en_pipeline <= {mul_en_pipeline[3:0], mul_en_in};
    end

    // Register inputs only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 0: Generate grouped partial sums and register them
    // Group bits in pairs: (b0,b1), (b2,b3), (b4,b5), (b6,b7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_sum0 <= 16'd0;
            pp_sum1 <= 16'd0;
            pp_sum2 <= 16'd0;
            pp_sum3 <= 16'd0;
        end else if (mul_en_pipeline[0]) begin
            // Partial products for bits 0 and 1
            pp_sum0 <= (mul_b_reg[0] ? ( {8'd0, mul_a_reg} << 0 ) : 16'd0) +
                       (mul_b_reg[1] ? ( {8'd0, mul_a_reg} << 1 ) : 16'd0);
            // bits 2 and 3
            pp_sum1 <= (mul_b_reg[2] ? ( {8'd0, mul_a_reg} << 2 ) : 16'd0) +
                       (mul_b_reg[3] ? ( {8'd0, mul_a_reg} << 3 ) : 16'd0);
            // bits 4 and 5
            pp_sum2 <= (mul_b_reg[4] ? ( {8'd0, mul_a_reg} << 4 ) : 16'd0) +
                       (mul_b_reg[5] ? ( {8'd0, mul_a_reg} << 5 ) : 16'd0);
            // bits 6 and 7
            pp_sum3 <= (mul_b_reg[6] ? ( {8'd0, mul_a_reg} << 6 ) : 16'd0) +
                       (mul_b_reg[7] ? ( {8'd0, mul_a_reg} << 7 ) : 16'd0);
        end
    end

    // Stage 1: Add pairs of partial sums and register them
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_0 <= 16'd0;
            sum_stage1_1 <= 16'd0;
        end else if (mul_en_pipeline[1]) begin
            sum_stage1_0 <= pp_sum0 + pp_sum1;
            sum_stage1_1 <= pp_sum2 + pp_sum3;
        end
    end

    // Stage 2: Final sum and register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipeline[2])
            mul_out_reg <= sum_stage1_0 + sum_stage1_1;
    end

    // Output enable delayed through pipeline stages
    assign mul_en_out = mul_en_pipeline[3];

    // Output product gated by enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule