module multi_pipe_8bit (
    input              clk,
    input              rst_n,       // Active-low synchronous reset
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline registers for input enable, 5-stage pipeline to balance additions
reg [4:0] mul_en_pipe;

// Input operand registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires: 8 partial products shifted by bit position
wire [15:0] partial_prod [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : GEN_PARTIAL_PROD
        assign partial_prod[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 1: Capture inputs when enabled
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_pipe <= 5'b0;
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

// Stage 2: Sum partial_prod[0..2] with carry-save approach
reg [15:0] sum_stage2_0, carry_stage2_0;
wire [15:0] sum_stage2_0_w, carry_stage2_0_w;

// Carry-save addition of three operands: partial_prod[0], partial_prod[1], partial_prod[2]
assign sum_stage2_0_w = partial_prod[0] ^ partial_prod[1] ^ partial_prod[2];
assign carry_stage2_0_w = ((partial_prod[0] & partial_prod[1]) | (partial_prod[1] & partial_prod[2]) | (partial_prod[0] & partial_prod[2])) << 1;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage2_0 <= 16'd0;
        carry_stage2_0 <= 16'd0;
    end else if (mul_en_pipe[1]) begin
        sum_stage2_0 <= sum_stage2_0_w;
        carry_stage2_0 <= carry_stage2_0_w;
    end else begin
        sum_stage2_0 <= 16'd0;
        carry_stage2_0 <= 16'd0;
    end
end

// Stage 3: Sum partial_prod[3..5] with carry-save approach
reg [15:0] sum_stage3_0, carry_stage3_0;
wire [15:0] sum_stage3_0_w, carry_stage3_0_w;

assign sum_stage3_0_w = partial_prod[3] ^ partial_prod[4] ^ partial_prod[5];
assign carry_stage3_0_w = ((partial_prod[3] & partial_prod[4]) | (partial_prod[4] & partial_prod[5]) | (partial_prod[3] & partial_prod[5])) << 1;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage3_0 <= 16'd0;
        carry_stage3_0 <= 16'd0;
    end else if (mul_en_pipe[2]) begin
        sum_stage3_0 <= sum_stage3_0_w;
        carry_stage3_0 <= carry_stage3_0_w;
    end else begin
        sum_stage3_0 <= 16'd0;
        carry_stage3_0 <= 16'd0;
    end
end

// Stage 4: Sum partial_prod[6], partial_prod[7]
reg [15:0] sum_stage4_0, carry_stage4_0;
wire [15:0] sum_stage4_0_w, carry_stage4_0_w;

assign sum_stage4_0_w = partial_prod[6] ^ partial_prod[7];
assign carry_stage4_0_w = (partial_prod[6] & partial_prod[7]) << 1;

always @(posedge clk) begin
    if (!rst_n) begin
        sum_stage4_0 <= 16'd0;
        carry_stage4_0 <= 16'd0;
    end else if (mul_en_pipe[3]) begin
        sum_stage4_0 <= sum_stage4_0_w;
        carry_stage4_0 <= carry_stage4_0_w;
    end else begin
        sum_stage4_0 <= 16'd0;
        carry_stage4_0 <= 16'd0;
    end
end

// Stage 5: Final additions of all sums and carries
// First level: sum sum_stage2_0 + carry_stage2_0, sum_stage3_0 + carry_stage3_0, sum_stage4_0 + carry_stage4_0
reg [15:0] partial_sum0, partial_sum1, partial_sum2;
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum0 <= 16'd0;
        partial_sum1 <= 16'd0;
        partial_sum2 <= 16'd0;
    end else if (mul_en_pipe[4]) begin
        partial_sum0 <= sum_stage2_0 + carry_stage2_0;
        partial_sum1 <= sum_stage3_0 + carry_stage3_0;
        partial_sum2 <= sum_stage4_0 + carry_stage4_0;
    end else begin
        partial_sum0 <= 16'd0;
        partial_sum1 <= 16'd0;
        partial_sum2 <= 16'd0;
    end
end

// Stage 6 (final): sum all three partial sums to get the final product
reg [15:0] mul_out_reg;
reg mul_en_out_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        mul_en_out_reg <= 1'b0;
    end else begin
        mul_en_out_reg <= mul_en_pipe[4];
        if (mul_en_pipe[4])
            mul_out_reg <= partial_sum0 + partial_sum1 + partial_sum2;
        else
            mul_out_reg <= 16'd0;
    end
end

// Output assignments
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out <= 16'd0;
        mul_en_out <= 1'b0;
    end else begin
        mul_out <= mul_en_out_reg ? mul_out_reg : 16'd0;
        mul_en_out <= mul_en_out_reg;
    end
end

endmodule