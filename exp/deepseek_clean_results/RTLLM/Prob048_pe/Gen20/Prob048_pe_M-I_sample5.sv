module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Operand isolation and zero detection
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    wire inputs_zero = (a_eff == 0) || (b_eff == 0);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] acc_reg;
    reg signed [31:0] product_reg;

    // Output assignment
    assign c = acc_reg;

    // Stage 1: Register inputs and compute product
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            product_reg <= 32'b0;
        end else begin
            a_reg <= a_eff;
            b_reg <= b_eff;
            // Gate multiplier when inputs are zero
            product_reg <= inputs_zero ? 32'b0 : a_eff * b_eff;
        end
    end

    // Stage 2: Accumulate result
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'd0;
        end else begin
            acc_reg <= acc_reg + product_reg;
        end
    end

endmodule