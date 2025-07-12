module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 bits: input enable + 4 pipeline stages)
    reg [4:0] mul_en_pipe;

    // Input registers for operands, updated only on mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: 8 partial products of 16 bits each
    wire [15:0] partial_products[7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : PARTIAL_PRODUCTS_GEN
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Combinational sums for pipeline stage 1 (sum pairs)
    wire [15:0] sum_stage1_0_1 = partial_products[0] + partial_products[1];
    wire [15:0] sum_stage1_2_3 = partial_products[2] + partial_products[3];
    wire [15:0] sum_stage1_4_5 = partial_products[4] + partial_products[5];
    wire [15:0] sum_stage1_6_7 = partial_products[6] + partial_products[7];

    // Pipeline registers stage 1 sums
    reg [15:0] sum_0_1_reg, sum_2_3_reg, sum_4_5_reg, sum_6_7_reg;

    // Combinational sums for pipeline stage 2 (sum pairs from stage 1)
    wire [15:0] sum_stage2_01_23 = sum_0_1_reg + sum_2_3_reg;
    wire [15:0] sum_stage2_45_67 = sum_4_5_reg + sum_6_7_reg;

    // Pipeline registers stage 2 sums
    reg [15:0] sum_01_23_reg, sum_45_67_reg;

    // Combinational sum for pipeline stage 3 (final sum)
    wire [15:0] final_sum = sum_01_23_reg + sum_45_67_reg;

    // Pipeline register stage 3 result
    reg [15:0] mul_out_reg;

    // Pipeline enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // Input registers for operands, only latch when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Pipeline stage 1 registers capturing sum pairs when enable asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1_reg <= 16'b0;
            sum_2_3_reg <= 16'b0;
            sum_4_5_reg <= 16'b0;
            sum_6_7_reg <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_0_1_reg <= sum_stage1_0_1;
            sum_2_3_reg <= sum_stage1_2_3;
            sum_4_5_reg <= sum_stage1_4_5;
            sum_6_7_reg <= sum_stage1_6_7;
        end else begin
            sum_0_1_reg <= 16'b0;
            sum_2_3_reg <= 16'b0;
            sum_4_5_reg <= 16'b0;
            sum_6_7_reg <= 16'b0;
        end
    end

    // Pipeline stage 2 registers capturing sums when enable asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_23_reg <= 16'b0;
            sum_45_67_reg <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_01_23_reg <= sum_stage2_01_23;
            sum_45_67_reg <= sum_stage2_45_67;
        end else begin
            sum_01_23_reg <= 16'b0;
            sum_45_67_reg <= 16'b0;
        end
    end

    // Pipeline stage 3 register capturing final sum when enable asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[3])
            mul_out_reg <= final_sum;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable from MSB of enable shift register (stage 4)
    assign mul_en_out = mul_en_pipe[4];

    // Output product valid only if output enable asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule