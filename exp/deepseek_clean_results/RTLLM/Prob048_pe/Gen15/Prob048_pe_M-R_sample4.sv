module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product;
    wire signed [31:0] sum;

    // Explicit multiplication with truncation
    assign product = a * b;

    // Accumulation path
    assign sum = c + product;

    // Sequential update with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= sum;
        end
    end

endmodule