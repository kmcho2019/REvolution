module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline depth: 8 stages, one for each multiplier bit
    // Shift register to track pipeline valid state (enable pipeline)
    reg [7:0] en_pipeline;

    // Input registers for multiplicand and multiplier, capture when mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Accumulator register holding partial sums (16 bits) as we shift through multiplier bits
    reg [15:0] acc_reg;

    // Bit counter in pipeline implicitly represented by shift register en_pipeline

    // On each clock cycle when enabled, accumulate partial product for current bit of mul_b_reg
    // The least significant bit of en_pipeline corresponds to the current processing bit index.
    // When en_pipeline shifts right, the current bit index increments.

    // Implementation details:
    // 1) At mul_en_in assert, latch inputs and start en_pipeline with LSB=1, others zero.
    // 2) On each cycle, if enable pipeline LSB is high, accumulate partial product:
    //    acc_reg = acc_reg + (mul_b_reg[current_bit] ? (mul_a_reg << current_bit) : 0)
    // 3) Shift en_pipeline right to move to next bit.
    // 4) After 8 cycles, output enable mul_en_out asserted (MSB of en_pipeline), and acc_reg holds product.
    
    // Latching inputs and starting pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            en_pipeline <= 8'd0;
            acc_reg <= 16'd0;
        end else begin
            if (mul_en_in) begin
                // Start new multiplication sequence
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
                en_pipeline <= 8'b00000001; // Start at bit 0
                acc_reg <= 16'd0;           // Reset accumulator
            end else if (|en_pipeline) begin
                // Accumulate partial product for current bit
                // Find current bit index from en_pipeline LSB (which is always bit 0),
                // actually, since we shift right, current bit is the position of the LSB '1'.
                // But here, LSB corresponds to bit 0 processing, next cycle bit 1, etc.
                // So use position of '1' in en_pipeline, which is LSB.

                // Since only one '1' bit is in en_pipeline at a time, find which bit it is
                // Alternatively, keep a separate pipeline counter or just multiply by shifts.

                // Use a separate counter to track pipeline stage for clarity:
            end else begin
                en_pipeline <= 8'd0;
                acc_reg <= acc_reg; // Hold value when pipeline inactive
            end
        end
    end

    // To track current pipeline stage index, use a separate pipeline counter
    reg [3:0] stage_cnt; // 0 to 7 counting the multiplier bit being processed

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage_cnt <= 4'd0;
        else if (mul_en_in)
            stage_cnt <= 4'd0; // Reset at start of new multiplication
        else if (|en_pipeline)
            stage_cnt <= stage_cnt + 1'b1;
        else
            stage_cnt <= stage_cnt; // Hold
    end

    // Accumulate partial product for current bit stage
    wire [15:0] shifted_mul_a = {8'd0, mul_a_reg} << stage_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg <= 16'd0;
        end else if (mul_en_in) begin
            acc_reg <= 16'd0;
        end else if (|en_pipeline) begin
            // If the current bit of mul_b_reg is set, accumulate the shifted multiplicand
            if (mul_b_reg[stage_cnt])
                acc_reg <= acc_reg + shifted_mul_a;
            else
                acc_reg <= acc_reg;
            // Shift the enable pipeline right by 1 to move to next bit processing
            en_pipeline <= en_pipeline << 1;
        end
    end

    // Output enable is asserted when the MSB of en_pipeline is set, indicating completion
    assign mul_en_out = en_pipeline[7];

    // Output product muxed: valid when mul_en_out is high
    assign mul_out = mul_en_out ? acc_reg : 16'd0;

endmodule