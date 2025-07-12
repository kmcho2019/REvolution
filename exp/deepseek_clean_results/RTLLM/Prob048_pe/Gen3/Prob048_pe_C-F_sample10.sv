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
    wire signed [31:0] product;
    wire inputs_zero = (a == 32'd0) && (b == 32'd0);
    wire clk_en = ~inputs_zero || rst;  // Clock gating condition

    // Stage 1: Multiplication (combinational)
    assign product = a_reg * b_reg;

    // Clock gating implementation
    always @(posedge clk) begin
        if (clk_en) begin
            if (rst) begin
                // Synchronous reset
                c <= 32'd0;
                product_reg <= 32'd0;
                a_reg <= 32'd0;
                b_reg <= 32'd0;
            end else begin
                // Pipeline stage 1: Register inputs and product
                a_reg <= a;
                b_reg <= b;
                product_reg <= product;
                
                // Pipeline stage 2: Accumulation
                c <= c + product_reg;
            end
        end
    end

endmodule