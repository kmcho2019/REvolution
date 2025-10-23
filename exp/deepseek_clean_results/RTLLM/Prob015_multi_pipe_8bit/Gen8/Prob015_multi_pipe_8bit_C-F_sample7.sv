module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] mul_a_reg, mul_b_reg;
reg [1:0] en_pipeline;  // Reduced enable pipeline
reg [15:0] sum_intermediate;  // Intermediate sum register
reg [15:0] final_sum;  // Final sum register

// Gated partial products with early zero detection
wire [7:0] b_gated = mul_b_reg & {8{en_pipeline[0]}};
wire [15:0] partial_products [7:0];
wire [7:0] pp_enable = |b_gated ? 8'hFF : 8'h00;  // Early zero detection

// Generate partial products with conditional enable
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = pp_enable[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate

// Balanced adder tree with registered stages
wire [15:0] sum_stage1 = partial_products[0] + partial_products[1];
wire [15:0] sum_stage2 = partial_products[2] + partial_products[3];
wire [15:0] sum_stage3 = partial_products[4] + partial_products[5];
wire [15:0] sum_stage4 = partial_products[6] + partial_products[7];

// Clock gating control
wire output_clk_en = en_pipeline[1];
wire gated_clk;

// Clock gating cell
CLK_GATE output_clk_gate (
    .CLK(clk),
    .EN(output_clk_en),
    .GCLK(gated_clk)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        sum_intermediate <= 16'b0;
        final_sum <= 16'b0;
    end else begin
        // Pipeline stage 1: Register inputs
        en_pipeline <= {en_pipeline[0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: First level of addition
        sum_intermediate <= (sum_stage1 + sum_stage2) + (sum_stage3 + sum_stage4);
    end
end

// Pipeline stage 3: Final sum (clock gated)
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        final_sum <= sum_intermediate;
        mul_en_out <= 1'b1;
    end
end

// Continuous output assignment
assign mul_out = final_sum;

endmodule