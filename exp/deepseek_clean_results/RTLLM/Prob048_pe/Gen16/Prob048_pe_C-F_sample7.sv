module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    // Internal signals
    wire signed [2*WIDTH-1:0] full_product;
    wire signed [WIDTH-1:0] product_truncated;
    wire signed [WIDTH-1:0] next_c;

    // Combinational logic
    assign full_product = a * b;
    assign product_truncated = full_product[WIDTH-1:0];  // Explicit truncation
    assign next_c = rst ? {WIDTH{1'b0}} : (c + product_truncated);

    // Sequential logic
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule