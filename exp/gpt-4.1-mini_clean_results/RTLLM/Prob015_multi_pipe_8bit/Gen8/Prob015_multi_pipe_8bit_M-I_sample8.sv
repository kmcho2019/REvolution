module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline shift register (4 stages)
    reg [3:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (8 partial products)
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1: sum pairs of partial products (4 sums)
    reg [15:0] sum_stage1[3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1[0] <= 16'b0;
            sum_stage1[1] <= 16'b0;
            sum_stage1[2] <= 16'b0;
            sum_stage1[3] <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_stage1[0] <= partial_products[0] + partial_products[1];
            sum_stage1[1] <= partial_products[2] + partial_products[3];
            sum_stage1[2] <= partial_products[4] + partial_products[5];
            sum_stage1[3] <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage1[0] <= 16'b0;
            sum_stage1[1] <= 16'b0;
            sum_stage1[2] <= 16'b0;
            sum_stage1[3] <= 16'b0;
        end
    end

    // Stage 2: sum pairs of Stage 1 outputs (2 sums)
    reg [15:0] sum_stage2[1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
            sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
        end else begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
        end
    end

    // Stage 3: sum Stage 2 outputs to get final product
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage2[0] + sum_stage2[1];
        end else begin
            mul_out_reg <= 16'b0;
        end
    end

    // Enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Sample inputs only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Output enable from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when output enable is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule