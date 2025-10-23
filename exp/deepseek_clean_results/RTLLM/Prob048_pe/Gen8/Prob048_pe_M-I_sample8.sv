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

    // Stage 1: Multiplication
    wire signed [31:0] product = a * b;

    // Stage 2: Accumulation
    wire signed [31:0] accumulated = c_reg + product_reg;

    // Sequential logic
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 32'd0;
            c_reg <= 32'd0;
            c <= 32'd0;
        end else begin
            product_reg <= product;
            c_reg <= c;
            c <= accumulated;
        end
    end

endmodule