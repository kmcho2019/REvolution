module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [63:0] product_reg;
    reg enable;

    // Saturation constants
    localparam signed [31:0] MAX_VAL = 32'h7FFFFFFF;
    localparam signed [31:0] MIN_VAL = 32'h80000000;

    // Enable logic - disable during reset
    always @(posedge clk) begin
        enable <= ~rst;
    end

    // Stage 1: Multiply
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Stage 2: Accumulate with saturation
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (enable) begin
            // Check for overflow/underflow
            if ((product_reg[63] == product_reg[31]) || 
                ((c[31] == product_reg[63:32][31]) && 
                 (c[31] != (c + product_reg[31:0])[31]))) begin
                c <= c + product_reg[31:0];
            end else begin
                // Saturate
                c <= (product_reg[63]) ? MIN_VAL : MAX_VAL;
            end
        end
    end

endmodule