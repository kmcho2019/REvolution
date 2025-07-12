module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Clock gating control
wire clk_gated = clk & (mul_en_in | |en_pipeline);

// Pipeline control
reg [1:0] en_pipeline;  // 2-bit enable shift register

// Stage 1: Input registers
reg [7:0] mul_a_reg, mul_b_reg;

// Stage 2: Partial products
reg [15:0] pp_low_reg, pp_high_reg;  // Packed storage

// Stage 3: Intermediate sums
reg [15:0] sum_reg;

// Stage 4: Final result
reg [15:0] result_reg;

// Partial products with operand isolation
wire [15:0] pp [3:0];
assign pp[0] = (mul_b_reg[0] & en_pipeline[0]) ? {8'b0, mul_a_reg} : 16'b0;
assign pp[1] = (mul_b_reg[1] & en_pipeline[0]) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
assign pp[2] = (mul_b_reg[2] & en_pipeline[0]) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
assign pp[3] = (mul_b_reg[3] & en_pipeline[0]) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
assign pp[4] = (mul_b_reg[4] & en_pipeline[0]) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
assign pp[5] = (mul_b_reg[5] & en_pipeline[0]) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
assign pp[6] = (mul_b_reg[6] & en_pipeline[0]) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
assign pp[7] = (mul_b_reg[7] & en_pipeline[0]) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;

// Balanced adder tree with pipelining
wire [15:0] sum01 = pp[0] + pp[1];
wire [15:0] sum23 = pp[2] + pp[3];
wire [15:0] sum45 = pp[4] + pp[5];
wire [15:0] sum67 = pp[6] + pp[7];
wire [15:0] sum_low = sum01 + sum23;
wire [15:0] sum_high = sum45 + sum67;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        en_pipeline <= 2'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        pp_low_reg <= 16'b0;
        pp_high_reg <= 16'b0;
        sum_reg <= 16'b0;
        result_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Input registration
        en_pipeline <= {en_pipeline[0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: Partial product sums
        pp_low_reg <= sum_low;
        pp_high_reg <= sum_high;

        // Pipeline stage 3: Intermediate sum
        sum_reg <= pp_low_reg + pp_high_reg;

        // Pipeline stage 4: Final result
        result_reg <= sum_reg;
        
        // Output gating
        mul_en_out <= en_pipeline[1];
        if (en_pipeline[1]) begin
            mul_out <= result_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule