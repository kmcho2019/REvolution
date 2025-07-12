module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products (array size = size)
    // For each bit i of mul_b:
    // if mul_b[i] == 1 => partial_products[i] = ext_mul_a << i
    // else partial_products[i] = 0
    genvar i;
    wire [2*size-1:0] partial_products [0:size-1];
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline stages:
    // Stage 1: Sum partial products in two halves and register these intermediate sums.
    // Stage 2: Sum the two stage 1 registered sums and register the final output.

    // For size=4, split partial_products as:
    //   group0: partial_products[0], partial_products[1]
    //   group1: partial_products[2], partial_products[3]

    wire [2*size-1:0] stage1_sum0_comb = partial_products[0] + partial_products[1];
    wire [2*size-1:0] stage1_sum1_comb = partial_products[2] + partial_products[3];

    // Stage 1 pipeline registers for intermediate sums
    reg [2*size-1:0] stage1_sum0_reg, stage1_sum1_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum0_reg <= {2*size{1'b0}};
            stage1_sum1_reg <= {2*size{1'b0}};
        end else begin
            stage1_sum0_reg <= stage1_sum0_comb;
            stage1_sum1_reg <= stage1_sum1_comb;
        end
    end

    // Stage 2 combinational sum of registered intermediate sums
    wire [2*size-1:0] stage2_sum_comb = stage1_sum0_reg + stage1_sum1_reg;

    // Stage 2 pipeline register: final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_sum_comb;
        end
    end

endmodule