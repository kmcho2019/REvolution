module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [63:0] product_reg;
    wire signed [63:0] product;

    // Power-optimized multiplication (gated during reset)
    assign product = rst ? 64'd0 : a * b;

    // Two-stage pipeline:
    // Stage 1: Register multiplier output
    // Stage 2: Accumulate result
    always @(posedge clk) begin
        // Pipeline stage 1: Register multiplier output
        product_reg <= product;

        // Pipeline stage 2: Accumulation or reset
        if (rst) begin
            c <= 32'd0;  // Synchronous reset
        end else begin
            // Accumulate lower 32 bits (truncation with proper sign handling)
            c <= c + product_reg[31:0];
        end
    end

endmodule