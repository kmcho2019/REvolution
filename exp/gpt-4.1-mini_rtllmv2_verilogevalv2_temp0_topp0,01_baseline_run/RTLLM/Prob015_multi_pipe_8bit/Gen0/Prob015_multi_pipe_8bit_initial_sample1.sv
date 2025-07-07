module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

// Pipeline stage 1: Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg       <= 8'd0;
        mul_b_reg       <= 8'd0;
        mul_en_reg_stage1 <= 1'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg       <= mul_a;
            mul_b_reg       <= mul_b;
        end
        mul_en_reg_stage1 <= mul_en_in;
    end
end

// Partial product generation (wires)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stage 2: sum partial products in pairs (4 sums)
reg [15:0] sum_stage2 [3:0];
reg        mul_en_reg_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
        sum_stage2[2] <= 16'd0;
        sum_stage2[3] <= 16'd0;
        mul_en_reg_stage2 <= 1'b0;
    end else begin
        sum_stage2[0] <= partial_products[0] + partial_products[1];
        sum_stage2[1] <= partial_products[2] + partial_products[3];
        sum_stage2[2] <= partial_products[4] + partial_products[5];
        sum_stage2[3] <= partial_products[6] + partial_products[7];
        mul_en_reg_stage2 <= mul_en_reg_stage1;
    end
end

// Pipeline stage 3: sum pairs of sums from stage 2 (2 sums)
reg [15:0] sum_stage3 [1:0];
reg        mul_en_reg_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        mul_en_reg_stage3 <= 1'b0;
    end else begin
        sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
        sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        mul_en_reg_stage3 <= mul_en_reg_stage2;
    end
end

// Pipeline stage 4: final sum
reg [15:0] mul_out_reg;
reg        mul_en_reg_stage4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        mul_en_reg_stage4 <= 1'b0;
    end else begin
        mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        mul_en_reg_stage4 <= mul_en_reg_stage3;
    end
end

// Output assignments
assign mul_en_out = mul_en_reg_stage4;
assign mul_out = mul_en_reg_stage4 ? mul_out_reg : 16'd0;

endmodule