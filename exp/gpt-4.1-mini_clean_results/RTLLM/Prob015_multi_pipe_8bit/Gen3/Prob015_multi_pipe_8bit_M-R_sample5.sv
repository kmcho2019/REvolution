module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline registers for enable signal (5 stages for input, partial products, sums, and output)
reg [4:0] mul_en_pipe;

// Operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products: 8 wires of 16 bits each (multiplicand shifted by multiplier bit)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline registers for partial sums
reg [15:0] sum_stage1_0, sum_stage1_1, sum_stage1_2, sum_stage1_3;
reg [15:0] sum_stage2_0, sum_stage2_1;
reg [15:0] sum_stage3;

// Input register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'd0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: group partial products into four sums (2 or 3 operands each)
// This balances the adder tree by first adding pairs/triples of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
        sum_stage1_3 <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage1_0 <= partial_products[0] + partial_products[1];
        sum_stage1_1 <= partial_products[2] + partial_products[3];
        sum_stage1_2 <= partial_products[4] + partial_products[5];
        sum_stage1_3 <= partial_products[6] + partial_products[7];
    end else begin
        sum_stage1_0 <= 16'd0;
        sum_stage1_1 <= 16'd0;
        sum_stage1_2 <= 16'd0;
        sum_stage1_3 <= 16'd0;
    end
end

// Stage 2: add the four sums into two sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
        sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
    end else begin
        sum_stage2_0 <= 16'd0;
        sum_stage2_1 <= 16'd0;
    end
end

// Stage 3: final sum to get product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3 <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        sum_stage3 <= sum_stage2_0 + sum_stage2_1;
    end else begin
        sum_stage3 <= 16'd0;
    end
end

// Output stage: register output and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= mul_en_pipe[4];
        if (mul_en_pipe[4])
            mul_out <= sum_stage3;
        else
            mul_out <= 16'd0;
    end
end

endmodule