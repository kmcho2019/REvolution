module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Continuous assignment for multiplication
    wire signed [63:0] product;
    assign product = a * b;

    // Truncated product for accumulation
    wire signed [31:0] truncated_product;
    assign truncated_product = product[31:0];

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;
        end else begin
            c <= c + truncated_product;
        end
    end

endmodule