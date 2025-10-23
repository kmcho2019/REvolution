module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Full precision multiplication (combinational)
    wire signed [63:0] full_product;
    assign full_product = a * b;

    // Truncated 32-bit product (combinational)
    wire signed [31:0] truncated_product;
    assign truncated_product = full_product[31:0];

    // Sequential accumulation
    always @(posedge clk) begin
        c <= rst ? 32'sd0 : (c + truncated_product);
    end

endmodule