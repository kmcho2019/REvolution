module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    wire signed [63:0] product;
    wire clk_en;
    
    // Clock gating when inputs are zero
    assign clk_en = (a != 0) || (b != 0) || rst;
    
    // First pipeline stage: Register inputs and compute product
    always @(posedge clk) begin
        if (clk_en) begin
            if (rst) begin
                a_reg <= 32'd0;
                b_reg <= 32'd0;
            end else begin
                a_reg <= a;
                b_reg <= b;
            end
            product_reg <= a_reg * b_reg;  // Registered multiplier output
        end
    end

    // Second pipeline stage: Accumulate with overflow handling
    always @(posedge clk) begin
        if (clk_en) begin
            if (rst) begin
                c <= 32'd0;
            end else begin
                // Overflow detection and saturation
                if ((product_reg > 0) && (c > (32'h7FFFFFFF - product_reg[31:0]))) begin
                    c <= 32'h7FFFFFFF;  // Positive saturation
                end else if ((product_reg < 0) && (c < (32'h80000000 - product_reg[31:0]))) begin
                    c <= 32'h80000000;  // Negative saturation
                end else begin
                    c <= c + product_reg[31:0];
                end
            end
        end
    end

endmodule