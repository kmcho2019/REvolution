module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Registered intermediate signals
    reg signed [31:0] product_reg;
    wire signed [63:0] product;

    // Combinational multiplier
    assign product = a * b;

    // Register the product (lower 32 bits)
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 32'd0;
        end else begin
            product_reg <= product[31:0];
        end
    end

    // Accumulator
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_reg;
        end
    end

endmodule