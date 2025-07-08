module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    wire signed [31:0] product;

    // Multiply a and b
    assign product = a * b;

    // Accumulate on clock edge
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;  // Reset accumulation register
        end else begin
            c <= c + product;  // Accumulate product
        end
    end

endmodule