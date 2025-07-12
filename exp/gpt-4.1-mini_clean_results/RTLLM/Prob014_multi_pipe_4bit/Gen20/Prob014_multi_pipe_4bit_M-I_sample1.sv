module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
) (
    input                       clk,
    input                       rst_n,
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by size zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Pipeline stage 1: sum partial products pairwise and register sums
    reg [product_width-1:0] pp_sum1_stage1, pp_sum2_stage1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_sum1_stage1 <= {product_width{1'b0}};
            pp_sum2_stage1 <= {product_width{1'b0}};
        end else begin
            pp_sum1_stage1 <= partial_products[0] + partial_products[1];
            pp_sum2_stage1 <= partial_products[2] + partial_products[3];
        end
    end

    // Pipeline stage 2: sum registered partial sums and register final product
    reg [product_width-1:0] product_reg_stage2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg_stage2 <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            product_reg_stage2 <= pp_sum1_stage1 + pp_sum2_stage1;
            mul_out <= product_reg_stage2;
        end
    end

endmodule