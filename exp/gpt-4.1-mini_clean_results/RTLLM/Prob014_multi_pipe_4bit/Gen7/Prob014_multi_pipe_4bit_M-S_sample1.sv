module multi_pipe_4bit #(
    parameter size = 4
)(
    input                  clk,
    input                  rst_n,
    input  [size-1:0]      mul_a,
    input  [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by size zeros at MSB
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Partial products for each bit of mul_b
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Level 1 registers: two intermediate sums (sum lower half and sum upper half)
    reg [2*size-1:0] stage1_sum_low;
    reg [2*size-1:0] stage1_sum_high;

    // Level 2 register: final product sum
    reg [2*size-1:0] stage2_sum;

    // Stage 1: sum partial products of bits 0 and 1, bits 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= 0;
            stage1_sum_high <= 0;
        end else begin
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];
        end
    end

    // Stage 2: sum of intermediate sums to get final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            mul_out    <= 0;
        end else begin
            stage2_sum <= stage1_sum_low + stage1_sum_high;
            mul_out    <= stage2_sum;
        end
    end

endmodule