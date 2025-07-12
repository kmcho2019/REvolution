module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                     clk,
    input                     rst_n,    // active low reset
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend mul_a and mul_b by size zeros at MSB side
    // For mul_a: extended as {size{0}, mul_a} (8 bits)
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};
    wire [size-1:0] mul_b_reg;

    // Register mul_b for stable partial product generation in stage 1
    reg [size-1:0] mul_b_stage1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_b_stage1 <= 0;
        else
            mul_b_stage1 <= mul_b;
    end

    // First pipeline stage: Generate partial products
    // Each partial product width = product_width = 8 bits
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b_stage1[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products
    reg [product_width-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= 0;
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2 registers: sum partial products in a binary tree manner and register sums
    // For size=4:
    // level 1 sums: sum0 = pp_reg[0] + pp_reg[1], sum1 = pp_reg[2] + pp_reg[3]
    reg [product_width-1:0] sum_reg [0:1];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg[0] <= 0;
            sum_reg[1] <= 0;
        end else begin
            sum_reg[0] <= pp_reg[0] + pp_reg[1];
            sum_reg[1] <= pp_reg[2] + pp_reg[3];
        end
    end

    // Final output register: sum of the two sums
    reg [product_width-1:0] final_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_reg <= 0;
            mul_out <= 0;
        end else begin
            final_reg <= sum_reg[0] + sum_reg[1];
            mul_out <= final_reg;
        end
    end

endmodule