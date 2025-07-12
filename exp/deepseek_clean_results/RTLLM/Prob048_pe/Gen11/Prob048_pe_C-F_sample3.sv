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
    wire signed [63:0] product;
    wire inputs_zero = (a == 32'd0) && (b == 32'd0);
    wire clk_en = ~rst && ~inputs_zero;

    // Stage 1: Multiplication (registered)
    assign product = a_reg * b_reg;

    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            product_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            product_reg <= product[31:0];
        end
    end

    // Stage 2: Accumulation (with clock gating)
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else if (clk_en) begin
            c <= c + product_reg;
        end
    end

endmodule