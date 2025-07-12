module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] product_reg;
    reg signed [31:0] a_reg, b_reg;
    reg rst_d1;

    // Synchronize reset
    always @(posedge clk) begin
        rst_d1 <= rst;
    end

    // Stage 1: Multiplication pipeline
    always @(posedge clk) begin
        if (rst_d1) begin
            product_reg <= 32'd0;
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            product_reg <= a * b;  // Direct 32-bit multiplication
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Stage 2: Accumulation pipeline
    always @(posedge clk) begin
        if (rst_d1) begin
            c <= 32'd0;
        end else begin
            c <= c + product_reg;
        end
    end

endmodule