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

    always @(posedge clk) begin
        if (rst) begin
            // Clear all pipeline registers on reset
            product_reg <= 32'd0;
            c_reg <= 32'd0;
            c <= 32'd0;
        end else begin
            // Pipeline stage 1: register product
            product_reg <= product;
            
            // Pipeline stage 2: register accumulation
            c_reg <= accumulated;
            
            // Output register
            c <= c_reg;
        end
    end

endmodule