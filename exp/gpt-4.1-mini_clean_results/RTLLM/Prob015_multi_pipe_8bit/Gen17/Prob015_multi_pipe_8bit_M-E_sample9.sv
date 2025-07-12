module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers for enable tracking (5 stages)
    reg [4:0] mul_en_pipe;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Pipeline registers for accumulated partial sums
    reg [15:0] sum_stage [0:4]; // 5 stages, sum_stage[0] is first accumulation after stage 0

    integer stage_i;

    // Shift mul_en_in through pipeline to track valid data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // Sample inputs on mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Pipeline stage 0: start accumulation with 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_stage[0] <= 16'd0;
        else if (mul_en_pipe[0]) begin
            // Add partial product for bit 0 of mul_b_reg
            sum_stage[0] <= (mul_b_reg[0]) ? (mul_a_reg) : 16'd0;
        end else
            sum_stage[0] <= 16'd0;
    end

    // Pipeline stages 1 to 4: accumulate partial products for bits 1 to 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (stage_i = 1; stage_i < 5; stage_i = stage_i + 1)
                sum_stage[stage_i] <= 16'd0;
        end else begin
            // Stage 1 accumulates bit 1
            if (mul_en_pipe[1])
                sum_stage[1] <= sum_stage[0] + (mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0);
            else
                sum_stage[1] <= 16'd0;

            // Stage 2 accumulates bit 2
            if (mul_en_pipe[2])
                sum_stage[2] <= sum_stage[1] + (mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0);
            else
                sum_stage[2] <= 16'd0;

            // Stage 3 accumulates bit 3
            if (mul_en_pipe[3])
                sum_stage[3] <= sum_stage[2] + (mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0);
            else
                sum_stage[3] <= 16'd0;

            // Stage 4 accumulates bit 4
            if (mul_en_pipe[4])
                sum_stage[4] <= sum_stage[3] + (mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0);
            else
                sum_stage[4] <= 16'd0;
        end
    end

    // Since bits 5 to 7 are still not processed, extend pipeline similarly for bits 5,6,7
    // We will extend pipeline depth to 8 stages total to process all bits.

    // Extend mul_en_pipe to 8 bits to track all stages
    reg [7:0] mul_en_pipe_ext;

    // Extend mul_en_pipe pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe_ext <= 8'b0;
        else
            mul_en_pipe_ext <= {mul_en_pipe_ext[6:0], mul_en_in};
    end

    // Partial sums registers for stages 5 to 7
    reg [15:0] sum_stage_ext [5:7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage_ext[5] <= 16'd0;
            sum_stage_ext[6] <= 16'd0;
            sum_stage_ext[7] <= 16'd0;
        end else begin
            // Stage 5 (bit 5)
            if (mul_en_pipe_ext[5])
                sum_stage_ext[5] <= sum_stage[4] + (mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0);
            else
                sum_stage_ext[5] <= 16'd0;

            // Stage 6 (bit 6)
            if (mul_en_pipe_ext[6])
                sum_stage_ext[6] <= sum_stage_ext[5] + (mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0);
            else
                sum_stage_ext[6] <= 16'd0;

            // Stage 7 (bit 7)
            if (mul_en_pipe_ext[7])
                sum_stage_ext[7] <= sum_stage_ext[6] + (mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0);
            else
                sum_stage_ext[7] <= 16'd0;
        end
    end

    // Output enable is asserted when the last pipeline stage (7) is valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe_ext[7];
    end

    // Output product register to hold final multiplication result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 16'd0;
        else if (mul_en_pipe_ext[7])
            mul_out <= sum_stage_ext[7];
        else
            mul_out <= 16'd0;
    end

endmodule