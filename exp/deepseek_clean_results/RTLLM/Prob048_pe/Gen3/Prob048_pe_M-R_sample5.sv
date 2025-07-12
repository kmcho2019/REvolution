module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product_truncated;
    wire signed [31:0] next_c;
    wire signed [63:0] full_product;

    // Operand isolation during reset
    wire signed [31:0] a_iso = rst ? 32'd0 : a;
    wire signed [31:0] b_iso = rst ? 32'd0 : b;

    // Combinational logic
    assign full_product = a_iso * b_iso;
    assign product_truncated = full_product[31:0];  // Explicit truncation
    assign next_c = rst ? 32'd0 : (c + product_truncated);

    // Sequential logic
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule