module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,    // active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};
    wire [product_width-1:0] mul_b_ext = {{size{1'b0}}, mul_b};

    // Generate partial products (size partial products)
    // Each partial product width = product_width
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // First pipeline stage: registers to hold partial products
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

    // Second pipeline stage: sum of all partial products registered
    reg [product_width-1:0] sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_reg <= 0;
        else begin
            // sum all partial products from stage 1 registers
            sum_reg <= pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
        end
    end

    // Output register updated at the same clock edge as sum_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= sum_reg;
    end

endmodule