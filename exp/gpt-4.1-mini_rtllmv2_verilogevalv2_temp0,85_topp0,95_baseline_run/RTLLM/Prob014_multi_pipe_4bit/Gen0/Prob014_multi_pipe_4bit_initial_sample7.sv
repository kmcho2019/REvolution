module multi_pipe_4bit #(
    parameter size = 4
)(
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [2*size-1:0]    mul_out
);

// Extend inputs by size bits (shift left by size bits)
wire [2*size-1:0] mul_a_ext = {mul_a, {size{1'b0}}};
wire [2*size-1:0] zero = {2*size{1'b0}};

// Partial products array
wire [2*size-1:0] partial_products [0:size-1];

genvar i;
generate
    for (i=0; i<size; i=i+1) begin : gen_pp
        assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : zero;
    end
endgenerate

// Registers to store intermediate sums for pipeline stages
reg [2*size-1:0] stage1_reg;  // First pipeline stage register
reg [2*size-1:0] stage2_reg;  // Second pipeline stage register

// First pipeline stage: sum partial products for bits 0 and 1
// If size>2, otherwise adjust accordingly
wire [2*size-1:0] stage1_sum = partial_products[0] + partial_products[1];

// Second pipeline stage: sum partial products for bits 2 and 3 plus stage1_reg
wire [2*size-1:0] stage2_sum = (partial_products[2] + partial_products[3]) + stage1_reg;

// First pipeline stage register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        stage1_reg <= 0;
    else
        stage1_reg <= stage1_sum;
end

// Second pipeline stage register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        stage2_reg <= 0;
    else
        stage2_reg <= stage2_sum;
end

// Output register update with final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 0;
    else
        mul_out <= stage2_reg;
end

endmodule