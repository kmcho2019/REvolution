module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline depth: 5 stages (Input latch + 4 accumulation stages)
    localparam PIPE_STAGES = 5;

    // Pipeline enable shift register to track valid data through pipeline
    reg [PIPE_STAGES-1:0] mul_en_pipe;

    // Input registers to latch operands when enable asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Registers to hold partial sum at each pipeline stage
    reg [15:0] partial_sum_stage1;
    reg [15:0] partial_sum_stage2;
    reg [15:0] partial_sum_stage3;
    reg [15:0] partial_sum_stage4;

    // Partial product wire for current bit of multiplier
    wire [15:0] partial_product_stage1;
    wire [15:0] partial_product_stage2;
    wire [15:0] partial_product_stage3;
    wire [15:0] partial_product_stage4;
    wire [15:0] partial_product_stage5;

    // On input, latch multiplicand and multiplier and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 0;
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[PIPE_STAGES-2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products corresponding to each multiplier bit at pipeline stages:
    // Stage 1 adds bit 0 partial product
    assign partial_product_stage1 = mul_b_reg[0] ? (mul_a_reg << 0) : 16'd0;

    // Stage 2 adds bit 1 partial product
    assign partial_product_stage2 = mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0;

    // Stage 3 adds bit 2 partial product
    assign partial_product_stage3 = mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0;

    // Stage 4 adds bit 3 partial product
    assign partial_product_stage4 = mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0;

    // Stage 5 adds bits 4 to 7 partial products together combinationally before final stage
    // We accumulate these upper bits here to fit within pipeline depth.
    wire [15:0] pp_upper_bits;
    assign pp_upper_bits = 
        (mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0) +
        (mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0) +
        (mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0) +
        (mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0);

    reg [15:0] partial_sum_stage5;

    // Pipeline accumulation:

    // Stage 1: accumulate bit0 partial product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_stage1 <= 16'd0;
        else if (mul_en_pipe[0])
            partial_sum_stage1 <= partial_product_stage1;
        else
            partial_sum_stage1 <= 16'd0;
    end

    // Stage 2: add bit1 partial product to previous sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_stage2 <= 16'd0;
        else if (mul_en_pipe[1])
            partial_sum_stage2 <= partial_sum_stage1 + partial_product_stage2;
        else
            partial_sum_stage2 <= 16'd0;
    end

    // Stage 3: add bit2 partial product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_stage3 <= 16'd0;
        else if (mul_en_pipe[2])
            partial_sum_stage3 <= partial_sum_stage2 + partial_product_stage3;
        else
            partial_sum_stage3 <= 16'd0;
    end

    // Stage 4: add bit3 partial product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_stage4 <= 16'd0;
        else if (mul_en_pipe[3])
            partial_sum_stage4 <= partial_sum_stage3 + partial_product_stage4;
        else
            partial_sum_stage4 <= 16'd0;
    end

    // Stage 5: add upper bits partial products (bits 4-7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_stage5 <= 16'd0;
        else if (mul_en_pipe[4])
            partial_sum_stage5 <= partial_sum_stage4 + pp_upper_bits;
        else
            partial_sum_stage5 <= 16'd0;
    end

    // Output enable is MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[PIPE_STAGES-1];

    // Output the final product when output enable is asserted, else zero
    assign mul_out = mul_en_out ? partial_sum_stage5 : 16'd0;

endmodule