module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal 64-bit product for full multiplication result
    wire signed [63:0] product;

    // Calculate the product
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset condition: clear the accumulator
            c <= 32'd0;
        end else begin
            // Accumulate the lower 32 bits of the product
            c <= c + product[31:0];
        end
    end

endmodule