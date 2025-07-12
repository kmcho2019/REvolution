module pe(
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [31:0] prod_reg;

    always @(posedge clk) begin
        if (rst) begin
            prod_reg <= 32'd0;
            c <= 32'd0;
        end else begin
            prod_reg <= a * b;
            c <= c + prod_reg;
        end
    end

endmodule