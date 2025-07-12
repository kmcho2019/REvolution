module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] product_reg;
    reg valid_product;

    // Clock gating logic
    wire inputs_non_zero = |a || |b;
    wire accum_enable = inputs_non_zero && !rst;

    // Pipeline stage 1: Multiplication
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 32'd0;
            valid_product <= 1'b0;
        end else begin
            product_reg <= a * b;  // Direct 32-bit signed multiplication
            valid_product <= inputs_non_zero;
        end
    end

    // Pipeline stage 2: Accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (valid_product) begin
            c <= c + product_reg;
        end
    end

endmodule