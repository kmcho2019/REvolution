module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] product_reg;
    reg signed [31:0] c_reg;

    // Stage 1: Multiplication (registered)
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 32'd0;
        end else begin
            product_reg <= a * b;  // Direct 32-bit multiplication
        end
    end

    // Stage 2: Accumulation (registered)
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
            c_reg <= 32'd0;
        end else begin
            c_reg <= c_reg + product_reg;
            c <= c_reg + product_reg;  // Output is one cycle delayed
        end
    end

endmodule