module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,      // Active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally for each bit of mul_b
    wire [product_width-1:0] partial_product_0 = mul_b[0] ? (mul_a_ext << 0) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_1 = mul_b[1] ? (mul_a_ext << 1) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_2 = mul_b[2] ? (mul_a_ext << 2) : {product_width{1'b0}};
    wire [product_width-1:0] partial_product_3 = mul_b[3] ? (mul_a_ext << 3) : {product_width{1'b0}};

    // Stage 1 registers: latch partial products
    reg [product_width-1:0] stage1_pp0;
    reg [product_width-1:0] stage1_pp1;
    reg [product_width-1:0] stage1_pp2;
    reg [product_width-1:0] stage1_pp3;

    // Stage 2 registers: sum pairs of partial products
    reg [product_width-1:0] stage2_sum01;
    reg [product_width-1:0] stage2_sum23;

    // Output register to finalize multiplication (sum of stage2 sums)
    reg [product_width-1:0] mul_out_reg;

    // Stage 1: latch partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp0 <= {product_width{1'b0}};
            stage1_pp1 <= {product_width{1'b0}};
            stage1_pp2 <= {product_width{1'b0}};
            stage1_pp3 <= {product_width{1'b0}};
        end else begin
            stage1_pp0 <= partial_product_0;
            stage1_pp1 <= partial_product_1;
            stage1_pp2 <= partial_product_2;
            stage1_pp3 <= partial_product_3;
        end
    end

    // Stage 2: sum pairs of stage 1 partial products and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum01 <= {product_width{1'b0}};
            stage2_sum23 <= {product_width{1'b0}};
        end else begin
            stage2_sum01 <= stage1_pp0 + stage1_pp1;
            stage2_sum23 <= stage1_pp2 + stage1_pp3;
        end
    end

    // Output register: sum final two partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out_reg <= stage2_sum01 + stage2_sum23;
            mul_out <= mul_out_reg;
        end
    end

endmodule