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

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Accumulate lower 32 bits of the product
            c <= c + product[31:0];
        end
    end

endmodule