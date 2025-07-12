module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] product_truncated;

    // Combinational logic
    assign product = a * b;
    assign product_truncated = product[31:0];  // Explicit 32-bit truncation

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;  // Clear on reset
        end else begin
            c <= c + product_truncated;  // Accumulate
        end
    end

endmodule