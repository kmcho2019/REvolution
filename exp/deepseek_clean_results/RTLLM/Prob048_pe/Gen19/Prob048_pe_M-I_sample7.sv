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
    reg signed [31:0] accum_reg;
    wire signed [63:0] full_product;
    wire signed [31:0] truncated_product;

    // Clock gating control
    wire compute_enable = ~rst;

    // Stage 1: Register inputs and compute partial products
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'sd0;
            b_reg <= 32'sd0;
        end else if (compute_enable) begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Stage 2: Final multiplication and accumulation
    assign full_product = a_reg * b_reg;
    assign truncated_product = full_product[31:0];

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;
            accum_reg <= 32'sd0;
        end else if (compute_enable) begin
            accum_reg <= c;
            c <= accum_reg + truncated_product;
        end
    end

endmodule