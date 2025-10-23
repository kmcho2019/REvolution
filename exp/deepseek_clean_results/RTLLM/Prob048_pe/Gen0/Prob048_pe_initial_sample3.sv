module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    wire signed [63:0] product;
    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= c + product[31:0];  // Accumulate lower 32 bits of product
        end
    end

endmodule