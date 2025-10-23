module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [31:0] product_reg;
    reg accumulate_en;

    // Clock gating logic - skip accumulation when inputs are zero
    always @(*) begin
        accumulate_en = (a != 0) || (b != 0);
    end

    // Pipeline Stage 1: Input register and multiplication
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            // Truncated 32x32 multiplication (only compute needed bits)
            product_reg <= a * b;
        end
    end

    // Pipeline Stage 2: Accumulation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (accumulate_en) begin
            c <= c + product_reg;
        end
    end

endmodule