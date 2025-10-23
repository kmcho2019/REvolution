module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Stage 1 registers for inputs
    reg [size-1:0] stage1_mul_a;
    reg [size-1:0] stage1_mul_b;

    // Extended multiplicand for shifting
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, stage1_mul_a};

    // Partial products combinationally generated from registered inputs
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : PARTIAL_GEN
            assign partial_products[i] = stage1_mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Sum of all partial products combinationally
    wire [2*size-1:0] partial_sum = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];

    // Stage 2 register for product
    reg [2*size-1:0] stage2_product;

    // Stage 1: register inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
        end else begin
            stage1_mul_a <= mul_a;
            stage1_mul_b <= mul_b;
        end
    end

    // Stage 2: register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_product <= 0;
            mul_out <= 0;
        end else begin
            stage2_product <= partial_sum;
            mul_out <= stage2_product;
        end
    end

endmodule