module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,          // active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Generate partial products: each partial product is either shifted mul_a or zero
    // Each partial product width = product_width = 2*size
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            // If mul_b[i] is 1, partial product = mul_a shifted by i, zero-extended to product_width
            assign partial_products[i] = mul_b[i] ? ({{(product_width - size){1'b0}}, mul_a} << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products
    reg [product_width-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= {product_width{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2 register: sum all partial products from stage 1 registers
    reg [product_width-1:0] sum_reg;
    always @(posedge clk) begin
        if (!rst_n) begin
            sum_reg <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            sum_reg <= pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
            mul_out <= sum_reg;
        end
    end

endmodule