module pe (
    input  wire        clk,
    input  wire        rst,    // asynchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    wire [31:0] product_lower;

    assign product_lower = a * b; // lower 32 bits of product

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_lower;
        end
    end

endmodule