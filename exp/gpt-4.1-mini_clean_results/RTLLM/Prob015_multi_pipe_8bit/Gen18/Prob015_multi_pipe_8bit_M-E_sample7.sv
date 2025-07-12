module multi_pipe_8bit (
    input            clk,
    input            rst_n,
    input            mul_en_in,
    input      [7:0] mul_a,
    input      [7:0] mul_b,
    output reg       mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline length = 5 stages for two multiplier bits per stage (except last)
    // Enable pipeline to track validity across 5 cycles
    reg [4:0] en_pipe;

    // Registers to hold inputs sampled at mul_en_in
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial sum pipeline registers, stage0 to stage4
    reg [15:0] partial_sum [0:4];

    // Multiplier bits slice indices per stage
    // stage 1 accumulates bits 0 and 1
    // stage 2 accumulates bits 2 and 3
    // stage 3 accumulates bits 4 and 5
    // stage 4 accumulates bits 6 and 7
    // stage 0 just passes zero sum

    integer i;

    // Asynchronous active-low reset and enable pipeline update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 5'b0;
        end else begin
            en_pipe <= {en_pipe[3:0], mul_en_in};
        end
    end

    // Register inputs when mul_en_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 0: Initialize partial sum to zero when en_pipe[0] asserted, else zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum[0] <= 16'd0;
        end else if (en_pipe[0]) begin
            partial_sum[0] <= 16'd0;
        end else begin
            partial_sum[0] <= 16'd0;
        end
    end

    // Function to generate partial product for two bits at a time
    // Inputs: multiplicand, 8-bit multiplier, low bit index (0,2,4,6)
    // Output: 16-bit partial product of mul_a_reg * (multiplier bits shifted accordingly)
    function [15:0] partial_product_2bits;
        input [7:0] a;
        input [7:0] b;
        input [2:0] bit_idx; // index of first bit (0,2,4,6)
        reg [15:0] product;
        reg [15:0] pp0, pp1;
        begin
            // bit0 of this stage
            pp0 = b[bit_idx] ? (a << bit_idx) : 16'd0;
            // bit1 of this stage (if bit_idx+1 <=7)
            if (bit_idx < 7)
                pp1 = b[bit_idx+1] ? (a << (bit_idx + 1)) : 16'd0;
            else
                pp1 = 16'd0;

            product = pp0 + pp1;
            partial_product_2bits = product;
        end
    endfunction

    // Pipeline stages 1 to 4: accumulate partial products for two bits per stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 1; i < 5; i = i + 1)
                partial_sum[i] <= 16'd0;
        end else begin
            // Stage 1 accumulates bits 0,1 and adds partial_sum[0]
            if (en_pipe[1])
                partial_sum[1] <= partial_sum[0] + partial_product_2bits(mul_a_reg, mul_b_reg, 0);
            else
                partial_sum[1] <= 16'd0;

            // Stage 2 accumulates bits 2,3 and adds partial_sum[1]
            if (en_pipe[2])
                partial_sum[2] <= partial_sum[1] + partial_product_2bits(mul_a_reg, mul_b_reg, 2);
            else
                partial_sum[2] <= 16'd0;

            // Stage 3 accumulates bits 4,5 and adds partial_sum[2]
            if (en_pipe[3])
                partial_sum[3] <= partial_sum[2] + partial_product_2bits(mul_a_reg, mul_b_reg, 4);
            else
                partial_sum[3] <= 16'd0;

            // Stage 4 accumulates bits 6,7 and adds partial_sum[3]
            if (en_pipe[4])
                partial_sum[4] <= partial_sum[3] + partial_product_2bits(mul_a_reg, mul_b_reg, 6);
            else
                partial_sum[4] <= 16'd0;
        end
    end

    // Output enable derived from last pipeline stage enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= en_pipe[4];
        end
    end

    // Output assignment: valid product when mul_en_out asserted, else 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'd0;
        end else if (mul_en_out) begin
            mul_out <= partial_sum[4];
        end else begin
            mul_out <= 16'd0;
        end
    end

endmodule