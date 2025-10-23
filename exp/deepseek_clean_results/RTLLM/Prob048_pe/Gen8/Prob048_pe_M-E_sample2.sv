module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] sum_reg, carry_reg;
    reg rst_d1;

    // Multiplier segmentation
    wire signed [31:0] a_high = a_reg[31:16];
    wire signed [31:0] a_low = {16'b0, a_reg[15:0]};
    wire signed [31:0] b_high = b_reg[31:16];
    wire signed [31:0] b_low = {16'b0, b_reg[15:0]};

    // Partial products
    wire signed [63:0] pp_ll = a_low * b_low;
    wire signed [63:0] pp_lh = a_low * b_high;
    wire signed [63:0] pp_hl = a_high * b_low;
    wire signed [63:0] pp_hh = a_high * b_high;

    // Combined product with proper shifting
    wire signed [63:0] partial_sum = pp_ll + (pp_lh << 16) + (pp_hl << 16);
    wire signed [63:0] partial_carry = (pp_hh << 32);

    // Carry-save accumulation
    wire signed [63:0] next_sum, next_carry;
    assign {next_carry, next_sum} = {sum_reg, 1'b0} + {carry_reg, 1'b0} + partial_sum + partial_carry;

    // Clock gating logic
    wire inputs_changed = (a != a_reg) || (b != b_reg);
    wire clk_en = inputs_changed || rst;

    // Main pipeline
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            sum_reg <= 64'b0;
            carry_reg <= 64'b0;
            c <= 32'b0;
            rst_d1 <= 1'b1;
        end else if (clk_en) begin
            a_reg <= a;
            b_reg <= b;
            
            if (rst_d1) begin
                sum_reg <= 64'b0;
                carry_reg <= 64'b0;
            end else begin
                sum_reg <= next_sum;
                carry_reg <= next_carry;
            end
            
            // Final accumulation with saturation
            if (&next_sum[63:32] == 1'b0 || |next_sum[63:32] == 1'b0) begin
                c <= next_sum[31:0];  // No overflow
            end else begin
                c <= next_sum[63] ? 32'h80000000 : 32'h7FFFFFFF;  // Saturate
            end
            
            rst_d1 <= 1'b0;
        end
    end

endmodule