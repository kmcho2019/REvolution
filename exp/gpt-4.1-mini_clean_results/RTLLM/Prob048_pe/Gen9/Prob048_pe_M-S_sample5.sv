module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    wire [63:0] product;
    wire [31:0] product_trunc;

    assign product = a * b;
    assign product_trunc = product[31:0];

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_trunc;
        end
    end

endmodule