module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output              mul_en_out,
    output reg  [15:0]  mul_out
);

// Pipeline registers for enable signal, 8 stages (to cover pipeline latency)
reg [7:0] mul_en_out_reg;

// Input registers for operands
reg [7:0] mul_a_reg, mul_b_reg;

// Partial products (each 16-bit to accommodate shifted value)
wire [15:0] partial_product [7:0];

// Registers for partial sums (pipeline stages)
reg [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4, sum_stage5, sum_stage6, sum_stage7;

// Output register for final product
reg [15:0] mul_out_reg;

// Input control and operand registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else begin
        // Shift enable pipeline, insert mul_en_in at LSB
        mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};

        // Sample inputs only when mul_en_in asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products by ANDing mul_a with each bit of mul_b, shifted accordingly
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_product
        assign partial_product[i] = (mul_b_reg[i] ? (mul_a_reg << i) : 16'd0);
    end
endgenerate

// Pipeline accumulation of partial products
// Stage 1: sum first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage1 <= 16'd0;
    else
        sum_stage1 <= partial_product[0] + partial_product[1];
end

// Stage 2: add third partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage2 <= 16'd0;
    else
        sum_stage2 <= sum_stage1 + partial_product[2];
end

// Stage 3: add fourth partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage3 <= 16'd0;
    else
        sum_stage3 <= sum_stage2 + partial_product[3];
end

// Stage 4: add fifth partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage4 <= 16'd0;
    else
        sum_stage4 <= sum_stage3 + partial_product[4];
end

// Stage 5: add sixth partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage5 <= 16'd0;
    else
        sum_stage5 <= sum_stage4 + partial_product[5];
end

// Stage 6: add seventh partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage6 <= 16'd0;
    else
        sum_stage6 <= sum_stage5 + partial_product[6];
end

// Stage 7: add eighth partial product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum_stage7 <= 16'd0;
    else
        sum_stage7 <= sum_stage6 + partial_product[7];
end

// Final product register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out_reg <= 16'd0;
    else
        mul_out_reg <= sum_stage7;
end

// Output enable is the MSB of the enable pipeline register
assign mul_en_out = mul_en_out_reg[7];

// Output assignment: valid product only when mul_en_out asserted, else zero
always @(*) begin
    if (mul_en_out)
        mul_out = mul_out_reg;
    else
        mul_out = 16'd0;
end

endmodule