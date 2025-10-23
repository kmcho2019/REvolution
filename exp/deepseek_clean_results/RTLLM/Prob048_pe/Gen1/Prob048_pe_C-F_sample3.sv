module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // 32-bit product since we only use lower 32 bits of multiplication
    wire signed [31:0] product;

    // Calculate the 32-bit portion of product we need
    assign product = (a * b)[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Asynchronous reset for more reliable initialization
            c <= 32'd0;
        end else begin
            // Accumulate the 32-bit product
            c <= c + product;
        end
    end

endmodule