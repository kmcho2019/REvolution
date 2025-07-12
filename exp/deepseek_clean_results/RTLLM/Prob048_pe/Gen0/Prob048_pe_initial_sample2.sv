module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal 64-bit multiplication result
    wire signed [63:0] product;

    // Compute the product
    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            // Synchronous reset
            c <= 32'd0;
        end else begin
            // Accumulate with truncation (taking lower 32 bits)
            c <= c + product[31:0];
        end
    end

endmodule