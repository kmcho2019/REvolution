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

    // Pipeline stage 1: Register partial products
    reg [product_width-1:0] pp_reg [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= {product_width{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Pipeline stage 2: Sum all partial products and register the final product
    reg [product_width-1:0] product_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product_reg <= {product_width{1'b0}};
        else
            product_reg <= pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= product_reg;
    end

endmodule