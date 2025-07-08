module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

// Pipeline registers for input enable signal (8 stages: one per bit of multiplier + final output)
reg [8:0] mul_en_shift;

// Input registers for multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires: 8 partial products, each 16 bits wide (shifted properly)
wire [15:0] partial_products [7:0];

// Generate partial products: each partial product is mul_a_reg & mul_b_reg[i], shifted left by i
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stages for addition of partial products:
// We will sum partial products in stages to pipeline the addition.
// Stage 1: sum partial_products[0] + partial_products[1], partial_products[2] + partial_products[3], partial_products[4] + partial_products[5], partial_products[6] + partial_products[7]
// Stage 2: sum stage1 results pairwise
// Stage 3: sum stage2 results to get final sum

// Stage 1 registers
reg [15:0] sum_stage1_0;
reg [15:0] sum_stage1_1;
reg [15:0] sum_stage1_2;
reg [15:0] sum_stage1_3;

// Stage 2 registers
reg [15:0] sum_stage2_0;
reg [15:0] sum_stage2_1;

// Stage 3 register (final sum)
reg [15:0] mul_out_reg;

// Output enable register to align with pipeline depth (3 addition stages + input register stage)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_en_shift <= 9'd0;
    else
        mul_en_shift <= {mul_en_shift[7:0], mul_en_in};
end

// Input registers capture inputs when mul_en_in is high
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Stage 1 additions (pipeline registers)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
        sum_stage1_3 <= 16'd0;
    end else begin
        sum_stage1_0 <= partial_products[0] + partial_products[1];
        sum_stage1_1 <= partial_products[2] + partial_products[3];
        sum_stage1_2 <= partial_products[4] + partial_products[5];
        sum_stage1_3 <= partial_products[6] + partial_products[7];
    end
end

// Stage 2 additions (pipeline registers)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
    end else begin
        sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
        sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
    end
end

// Stage 3 addition (final sum)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        mul_out_reg <= sum_stage2_0 + sum_stage2_1;
    end
end

// Output enable is MSB of mul_en_shift (after pipeline delays)
assign mul_en_out = mul_en_shift[8];

// Output product valid when mul_en_out is asserted, else 0
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule