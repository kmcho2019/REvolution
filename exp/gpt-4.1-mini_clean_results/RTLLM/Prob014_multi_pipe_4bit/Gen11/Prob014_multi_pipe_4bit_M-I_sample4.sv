module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // --- Generate partial products combinationally ---
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers for partial products ---
    reg [2*size-1:0] stage1_partial_product0;
    reg [2*size-1:0] stage1_partial_product1;
    reg [2*size-1:0] stage1_partial_product2;
    reg [2*size-1:0] stage1_partial_product3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_partial_product0 <= 0;
            stage1_partial_product1 <= 0;
            stage1_partial_product2 <= 0;
            stage1_partial_product3 <= 0;
        end else begin
            stage1_partial_product0 <= partial_products[0];
            stage1_partial_product1 <= partial_products[1];
            stage1_partial_product2 <= partial_products[2];
            stage1_partial_product3 <= partial_products[3];
        end
    end

    // --- Balanced adder tree for partial sums ---
    // Level 1 sums (two pairs)
    wire [2*size-1:0] sum_level1_0 = stage1_partial_product0 + stage1_partial_product1;
    wire [2*size-1:0] sum_level1_1 = stage1_partial_product2 + stage1_partial_product3;

    // Level 2 sum (final sum)
    wire [2*size-1:0] sum_level2 = sum_level1_0 + sum_level1_1;

    // --- Stage 2 register: final product ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= 0;
        else
            mul_out <= sum_level2;
    end

endmodule