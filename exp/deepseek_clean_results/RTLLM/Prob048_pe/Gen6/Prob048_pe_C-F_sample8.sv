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
    assign product_truncated = full_product[WIDTH-1:0];
    assign next_c = c + product_truncated;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= {WIDTH{1'b0}};  // Clear all bits
        end else begin
            c <= next_c;
        end
    end

endmodule