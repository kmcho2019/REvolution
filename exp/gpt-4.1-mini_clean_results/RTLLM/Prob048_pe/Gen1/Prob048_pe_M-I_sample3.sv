module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Multiply a and b producing 64-bit product
    wire [63:0] product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Accumulate only the lower 32 bits of product
            c <= c + product[31:0];
        end
    end

endmodule