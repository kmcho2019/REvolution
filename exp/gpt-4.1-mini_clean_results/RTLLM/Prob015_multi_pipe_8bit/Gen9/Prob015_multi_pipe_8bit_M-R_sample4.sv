module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stage enables (3 stages)
    reg [2:0] en_pipe;

    // Stage 0: input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products - combinational wires
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : PARTIAL_PRODUCT_GEN
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1: sum partial products in two balanced groups
    reg [15:0] sum_stage1_low;
    reg [15:0] sum_stage1_high;

    // Stage 2: sum final product
    reg [15:0] mul_out_reg;

    // Synchronous reset and enable propagation through pipeline
    always @(posedge clk) begin
        if (!rst_n) begin
            en_pipe <= 3'b0;
        end else begin
            en_pipe <= {en_pipe[1:0], mul_en_in};
        end
    end

    // Register inputs only when enabled (stage 0)
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1 registers: sum partial products in two groups
    always @(posedge clk) begin
        if (!rst_n) begin
            sum_stage1_low <= 16'd0;
            sum_stage1_high <= 16'd0;
        end else if (en_pipe[0]) begin
            sum_stage1_low <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
            sum_stage1_high <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
        end else begin
            sum_stage1_low <= 16'd0;
            sum_stage1_high <= 16'd0;
        end
    end

    // Stage 2 register: sum the two halves to get final product
    always @(posedge clk) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (en_pipe[1]) begin
            mul_out_reg <= sum_stage1_low + sum_stage1_high;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable and output product
    assign mul_en_out = en_pipe[2];
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule