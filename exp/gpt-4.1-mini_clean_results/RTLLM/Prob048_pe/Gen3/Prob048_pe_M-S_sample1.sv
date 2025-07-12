module pe (
    input wire clk,
    input wire rst,              // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    wire [31:0] product_low;

    assign product_low = a * b;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product_low;
        end
    end

endmodule