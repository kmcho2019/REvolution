module pe (
    input wire clk,
    input wire rst,              // asynchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [31:0] product_reg;

    // Stage 1: multiply a and b, register the product
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            product_reg <= 32'd0;
        end else begin
            product_reg <= a * b;
        end
    end

    // Stage 2: accumulate registered product into c
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_reg;
        end
    end

endmodule