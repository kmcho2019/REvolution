module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zero bits at MSB side
    // ext_mul_a = {size zeros, mul_a}
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    genvar i;

    // Generate combinational partial products: 
    // partial_product[i] = (mul_b[i] ? (ext_mul_a << i) : 0)
    wire [2*size-1:0] partial_products_comb [0:size-1];
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products_comb[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register inputs and partial products
    reg [size-1:0]          stage1_mul_b;
    reg [2*size-1:0]        stage1_ext_mul_a;
    reg [2*size-1:0]        stage1_partial_products [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_b <= {size{1'b0}};
            stage1_ext_mul_a <= {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= {2*size{1'b0}};
            end
        end else begin
            stage1_mul_b <= mul_b;
            stage1_ext_mul_a <= ext_mul_a;
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= partial_products_comb[j];
            end
        end
    end

    // Sum partial products combinationally from stage1 registers
    wire [2*size-1:0] stage2_sum_comb;
    reg [2*size-1:0] stage2_sum_reg;

    // Combinational sum of partial products from stage1
    // Because Verilog doesn't support reduction over arrays directly, do with a for-loop generate
    // Declare an internal reg and assign in always_comb or continuous assignment via reduction
    // Use a generate loop to sum combinationally

    // Use a function to sum partial products to keep code clean
    function [2*size-1:0] sum_partial_products;
        input [2*size-1:0] partials [0:size-1];
        integer k;
        reg [2*size-1:0] sum;
        begin
            sum = {2*size{1'b0}};
            for (k = 0; k < size; k = k + 1) begin
                sum = sum + partials[k];
            end
            sum_partial_products = sum;
        end
    endfunction

    assign stage2_sum_comb = sum_partial_products(stage1_partial_products);

    // Stage 2 registers: register the final sum and produce output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_reg <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            stage2_sum_reg <= stage2_sum_comb;
            mul_out <= stage2_sum_reg;
        end
    end

endmodule