module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    wire [31:0] product_trunc;

    // Multiply and truncate product to lower 32 bits
    assign product_trunc = a * b;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_trunc;
        end
    end

endmodule