module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Stage 1: Input registers
    reg             en_stage1;
    reg [7:0]       a_stage1;
    reg [7:0]       b_stage1;

    // Stage 2: Partial product accumulation registers
    reg             en_stage2;
    reg [7:0]       a_stage2;
    reg [7:0]       b_stage2;
    reg [15:0]      acc_stage2;
    reg [3:0]       bit_idx_stage2;

    // Stage 3: Accumulation registers (for pipeline isolation)
    reg             en_stage3;
    reg [7:0]       a_stage3;
    reg [7:0]       b_stage3;
    reg [15:0]      acc_stage3;
    reg [3:0]       bit_idx_stage3;

    // Stage 4: Output register
    reg             en_stage4;
    reg [15:0]      product_stage4;

    // Input register stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage1 <= 1'b0;
            a_stage1 <= 8'd0;
            b_stage1 <= 8'd0;
        end else begin
            en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                a_stage1 <= mul_a;
                b_stage1 <= mul_b;
            end
        end
    end

    // Pipeline progression and partial product accumulation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage2 <= 1'b0;
            a_stage2 <= 8'd0;
            b_stage2 <= 8'd0;
            acc_stage2 <= 16'd0;
            bit_idx_stage2 <= 4'd0;

            en_stage3 <= 1'b0;
            a_stage3 <= 8'd0;
            b_stage3 <= 8'd0;
            acc_stage3 <= 16'd0;
            bit_idx_stage3 <= 4'd0;

            en_stage4 <= 1'b0;
            product_stage4 <= 16'd0;
        end else begin
            // Stage 1 -> Stage 2: Initialize accumulator and bit index on new input
            en_stage2 <= en_stage1;
            a_stage2 <= a_stage1;
            b_stage2 <= b_stage1;
            acc_stage2 <= 16'd0;
            bit_idx_stage2 <= 4'd0;

            // Stage 2 -> Stage 3: Process one multiplier bit per cycle
            if (en_stage2) begin
                // Calculate partial product for current bit index
                // If bit of multiplier is 1, add multiplicand shifted by bit_idx to accumulator
                // Otherwise add 0
                // Accumulate partial product
                // Next bit index increments
                acc_stage3 <= acc_stage2 + ((b_stage2[bit_idx_stage2]) ? (a_stage2 << bit_idx_stage2) : 16'd0);
                bit_idx_stage3 <= bit_idx_stage2 + 1;
                en_stage3 <= 1'b1;
                a_stage3 <= a_stage2;
                b_stage3 <= b_stage2;
            end else begin
                // No valid multiplication in progress
                acc_stage3 <= 16'd0;
                bit_idx_stage3 <= 4'd0;
                en_stage3 <= 1'b0;
                a_stage3 <= 8'd0;
                b_stage3 <= 8'd0;
            end

            // Stage 3 -> Stage 4: Continue accumulation if bits remain; otherwise output final product
            if (en_stage3) begin
                if (bit_idx_stage3 < 8) begin
                    // More bits to process: feed back to stage 2 registers for next cycle
                    en_stage2 <= 1'b1;
                    a_stage2 <= a_stage3;
                    b_stage2 <= b_stage3;
                    acc_stage2 <= acc_stage3;
                    bit_idx_stage2 <= bit_idx_stage3;
                    en_stage3 <= 1'b0; // Clear stage3 to prevent output
                end else begin
                    // Completed all bits, output product
                    en_stage4 <= 1'b1;
                    product_stage4 <= acc_stage3;
                    en_stage3 <= 1'b0;
                end
            end else begin
                en_stage4 <= 1'b0;
                product_stage4 <= 16'd0;
            end
        end
    end

    // Output enable signal: delayed version of input enable by pipeline latency (8 cycles internally plus pipeline)
    reg [8:0] en_pipeline_shift;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline_shift <= 9'b0;
        end else begin
            en_pipeline_shift <= {en_pipeline_shift[7:0], mul_en_in};
        end
    end

    assign mul_en_out = en_pipeline_shift[8];

    // Output mux
    assign mul_out = mul_en_out ? product_stage4 : 16'd0;

endmodule