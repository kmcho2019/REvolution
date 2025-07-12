module pe (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);

reg [31:0] product;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        product <= 32'd0;
        c <= 32'd0;
    end else begin
        product <= a * b;
        c <= c + product;
    end
end

endmodule