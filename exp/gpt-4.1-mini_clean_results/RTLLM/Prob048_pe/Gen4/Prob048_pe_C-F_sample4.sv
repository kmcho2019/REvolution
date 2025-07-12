module pe (
    input wire clk,
    input wire rst,              // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    wire [63:0] product;
    wire [32:0] sum;

    assign product = a * b;
    assign sum = {1'b0, c} + {1'b0, product[31:0]};

    always @(posedge clk) begin
        if (rst)
            c <= 32'd0;
        else
            c <= sum[31:0];
    end

endmodule