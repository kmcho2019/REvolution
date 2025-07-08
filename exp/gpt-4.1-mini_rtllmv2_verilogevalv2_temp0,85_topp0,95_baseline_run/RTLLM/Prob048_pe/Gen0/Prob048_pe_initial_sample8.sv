module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // 64-bit product of a and b
    wire [63:0] product;
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            c <= c + product[31:0];
        end
    end

endmodule