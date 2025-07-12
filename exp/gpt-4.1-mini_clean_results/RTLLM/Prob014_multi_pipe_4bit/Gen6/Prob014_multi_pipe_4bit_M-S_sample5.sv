module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Generate partial products: for each bit i in mul_b,
    // if mul_b[i] is 1, partial product = mul_a shifted left by i, else 0
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i +1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? ({{size{1'b0}}, mul_a} << i) : {2*size{1'b0}};
            // multiplicand extended to 2*size bits by zero-padding MSBs to match product width
        end
    endgenerate

    // Pipeline registers for stage 1: sums of partial products bits 0,1 and 2,3
    reg [2*size-1:0] stage1_sum_low;
    reg [2*size-1:0] stage1_sum_high;

    // Pipeline register for stage 2: sum of stage1 sums
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= 0;
            stage1_sum_high <= 0;
            stage2_sum      <= 0;
            mul_out         <= 0;
        end else begin
            // Stage 1: sum partial products of bits 0 and 1
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            // Stage 1: sum partial products of bits 2 and 3
            stage1_sum_high <= partial_products[2] + partial_products[3];
            // Stage 2: sum of stage1 sums (final product)
            stage2_sum      <= stage1_sum_low + stage1_sum_high;
            // Output updated with final product
            mul_out         <= stage2_sum;
        end
    end

endmodule