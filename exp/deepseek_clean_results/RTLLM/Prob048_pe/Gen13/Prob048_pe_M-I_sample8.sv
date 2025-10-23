module pe (
    input wire clk,
    input wire rst,
    input wire en,        // Enable signal for power control
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    wire signed [63:0] product;
    wire clk_gated;

    // Clock gating logic
    assign clk_gated = clk & (en | rst);

    // Booth-encoded multiplier (simplified representation)
    // In practice, this would be implemented with Booth encoding logic
    assign product = a_reg * b_reg;

    // Operand isolation
    wire [31:0] a_iso = en ? a : 32'b0;
    wire [31:0] b_iso = en ? b : 32'b0;

    // Pipeline stage 1: Register inputs
    always @(posedge clk_gated) begin
        if (rst) begin
            a_reg <= 32'sd0;
            b_reg <= 32'sd0;
        end else if (en) begin
            a_reg <= a_iso;
            b_reg <= b_iso;
        end
    end

    // Pipeline stage 2: Register product
    always @(posedge clk_gated) begin
        if (rst) begin
            product_reg <= 64'sd0;
        end else if (en) begin
            product_reg <= product;
        end
    end

    // Accumulation stage
    always @(posedge clk_gated) begin
        if (rst) begin
            c <= 32'sd0;
        end else if (en) begin
            c <= c + product_reg[31:0];
        end
    end

endmodule