module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
) (
    input                     clk,
    input                     rst_n,       // async active-low reset
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by size zero bits on MSB side for alignment
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Pipeline Stage 1 registers:
    // Accumulate partial products for bits 0 and 1 of mul_b

    // Partial product for bit 0
    wire [product_width-1:0] pp0 = (mul_b[0]) ? (mul_a_ext << 0) : {product_width{1'b0}};
    // Partial product for bit 1
    wire [product_width-1:0] pp1 = (mul_b[1]) ? (mul_a_ext << 1) : {product_width{1'b0}};
    wire [product_width-1:0] sum_stage1_comb = pp0 + pp1;

    reg [product_width-1:0] sum_stage1_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_reg <= {product_width{1'b0}};
        end else begin
            sum_stage1_reg <= sum_stage1_comb;
        end
    end

    // Pipeline Stage 2 registers:
    // Accumulate partial products for bits 2 and 3 of mul_b plus previous sum_stage1_reg

    // Partial product for bit 2
    wire [product_width-1:0] pp2 = (mul_b[2]) ? (mul_a_ext << 2) : {product_width{1'b0}};
    // Partial product for bit 3
    wire [product_width-1:0] pp3 = (mul_b[3]) ? (mul_a_ext << 3) : {product_width{1'b0}};

    wire [product_width-1:0] sum_stage2_comb = sum_stage1_reg + pp2 + pp3;

    reg [product_width-1:0] sum_stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_reg <= {product_width{1'b0}};
        end else begin
            sum_stage2_reg <= sum_stage2_comb;
        end
    end

    // Output registered final product from stage 2 sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= sum_stage2_reg;
        end
    end

endmodule