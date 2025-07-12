module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,       // active low reset
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand by size bits on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Partial products wires array
    wire [product_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // First pipeline stage registers for partial products
    reg [product_width-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= {product_width{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                pp_reg[j] <= partial_products[j];
            end
        end
    end

    // Sum of registered partial products combinationally
    wire [product_width-1:0] sum_partial;
    assign sum_partial = pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];

    // Second pipeline stage: register final sum as output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= sum_partial;
    end

endmodule