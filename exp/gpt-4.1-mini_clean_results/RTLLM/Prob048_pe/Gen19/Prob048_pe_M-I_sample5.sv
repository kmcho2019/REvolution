module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [63:0] c
);

    reg [63:0] product_reg;

    // Stage 1: Multiply inputs and register product
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Stage 2: Accumulate registered product
    always @(posedge clk) begin
        if (rst) begin
            c <= 64'd0;
        end else begin
            c <= c + product_reg;
        end
    end

endmodule