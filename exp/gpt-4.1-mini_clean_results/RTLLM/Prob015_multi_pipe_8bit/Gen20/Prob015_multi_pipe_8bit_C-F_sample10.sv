module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (3 stages)
    reg mul_en_stage1, mul_en_stage2, mul_en_stage3;

    // Stage 1: input operand registers
    reg [7:0] mul_a_reg, mul_b_reg;

    // Stage 2: partial products and pairwise sums registers
    wire [15:0] partial_products [7:0];
    reg  [15:0] sum_stage2_reg [3:0];  // 4 pairwise sums registered here

    // Stage 3: final sum registers
    reg [15:0] sum_stage3_reg1, sum_stage3_reg2; // two sums registered
    reg [15:0] mul_out_reg;

    integer i;

    // 1) Enable pipeline shift registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage1 <= 1'b0;
            mul_en_stage2 <= 1'b0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            mul_en_stage2 <= mul_en_stage1;
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // 2) Input registers sampled on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Generate partial products (combinational)
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // 4) Stage 2: pairwise sum of partial products and register sums
    wire [15:0] pair_sums [3:0];
    assign pair_sums[0] = partial_products[0] + partial_products[1];
    assign pair_sums[1] = partial_products[2] + partial_products[3];
    assign pair_sums[2] = partial_products[4] + partial_products[5];
    assign pair_sums[3] = partial_products[6] + partial_products[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage2_reg[i] <= 16'd0;
        end else if (mul_en_stage1) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage2_reg[i] <= pair_sums[i];
        end
    end

    // 5) Stage 3: sum pairs of sums from stage 2 and register
    wire [15:0] sum_stage3_a = sum_stage2_reg[0] + sum_stage2_reg[1];
    wire [15:0] sum_stage3_b = sum_stage2_reg[2] + sum_stage2_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_reg1 <= 16'd0;
            sum_stage3_reg2 <= 16'd0;
        end else if (mul_en_stage2) begin
            sum_stage3_reg1 <= sum_stage3_a;
            sum_stage3_reg2 <= sum_stage3_b;
        end
    end

    // 6) Final product register (sum of sums from stage 3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_stage3) begin
            mul_out_reg <= sum_stage3_reg1 + sum_stage3_reg2;
        end
    end

    // Output enable aligned to output product
    assign mul_en_out = mul_en_stage3;

    // Output product gated by enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule