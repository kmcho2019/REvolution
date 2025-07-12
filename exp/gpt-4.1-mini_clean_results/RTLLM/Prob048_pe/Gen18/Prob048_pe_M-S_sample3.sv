module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    wire [31:0] product;
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 32'd0;
        else
            c <= c + product;
    end

endmodule