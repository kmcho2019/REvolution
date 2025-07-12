module multi_pipe_4bit #(
    parameter size = 4,
    localparam product_width = 2 * size
)(
    input                   clk,
    input                   rst_n,       // active low reset
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand to product width
    wire [product_width-1:0] mul_a_ext = {{(product_width - size){1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline registers: register partial products
    reg [product_width-1:0] stage1_pp [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_pp[j] <= {product_width{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_pp[j] <= partial_products[j];
        end
    end

    // Stage 2 pipeline register: register sum of all partial products from stage 1
    reg [product_width-1:0] stage2_sum;
    wire [product_width-1:0] sum_partial_products;

    // Combinational sum of stage1 partial products
    // Sum all registered partial products
    // Use a reduction add in a generate block or procedural sum
    // Here use a procedural sum for simplicity

    reg [product_width-1:0] sum_temp;
    always @* begin
        sum_temp = {product_width{1'b0}};
        for (j = 0; j < size; j = j + 1)
            sum_temp = sum_temp + stage1_pp[j];
    end
    assign sum_partial_products = sum_temp;

    // Register the sum in stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            stage2_sum <= sum_partial_products;
            mul_out <= stage2_sum;
        end
    end

endmodule