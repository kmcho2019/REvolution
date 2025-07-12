module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [2*WIDTH-1:0] product_stage1;
    wire signed [2*WIDTH-1:0] product = a_reg * b_reg;
    
    // Clock gating logic
    wire inputs_nonzero = |a || |b;
    wire clk_en = inputs_nonzero || rst;
    wire gated_clk = clk & clk_en;

    // Operand isolation
    wire signed [WIDTH-1:0] a_iso = clk_en ? a : 0;
    wire signed [WIDTH-1:0] b_iso = clk_en ? b : 0;

    // Pipeline stage 1: Register inputs
    always @(posedge gated_clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a_iso;
            b_reg <= b_iso;
        end
    end

    // Pipeline stage 2: Multiply
    always @(posedge gated_clk) begin
        if (rst) begin
            product_stage1 <= 0;
        end else begin
            product_stage1 <= product;
        end
    end

    // Pipeline stage 3: Accumulate (with truncation)
    always @(posedge gated_clk) begin
        if (rst) begin
            c <= 0;
        end else begin
            // Note: This intentionally truncates the product to WIDTH bits
            // Overflow behavior should be considered in system design
            c <= c + product_stage1[WIDTH-1:0];
        end
    end

endmodule