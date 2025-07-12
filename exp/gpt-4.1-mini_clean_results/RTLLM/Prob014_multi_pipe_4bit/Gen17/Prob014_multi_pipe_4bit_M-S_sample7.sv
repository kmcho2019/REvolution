module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2*size
) (
    input                       clk,
    input                       rst_n,       // async active-low reset
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Partial products array
    wire [product_width-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Pipeline stage 1 sum: bits 0 and 1 partial products
    wire [product_width-1:0] sum_stage1_comb = partial_products[0] + partial_products[1];
    reg [product_width-1:0] sum_stage1_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_stage1_reg <= {product_width{1'b0}};
        else
            sum_stage1_reg <= sum_stage1_comb;
    end

    // Pipeline stage 2 sum: bits 2 and 3 partial products plus previous sum
    wire [product_width-1:0] sum_stage2_comb = sum_stage1_reg + partial_products[2] + partial_products[3];
    reg [product_width-1:0] sum_stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_stage2_reg <= {product_width{1'b0}};
        else
            sum_stage2_reg <= sum_stage2_comb;
    end

    // Output registered final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_stage2_reg;
    end

endmodule