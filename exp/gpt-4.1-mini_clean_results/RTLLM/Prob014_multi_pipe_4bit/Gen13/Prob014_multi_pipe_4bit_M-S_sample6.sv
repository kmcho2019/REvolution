module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,       // active low async reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by zero padding on MSB side to product width
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products: mul_b[i] ? (mul_a_ext << i) : 0
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1: Register partial products (array of registers)
    reg [product_width-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Sum all registered partial products combinationally
    wire [product_width-1:0] pp_sum = pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];

    // Stage 2: Register final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= pp_sum;
    end

endmodule