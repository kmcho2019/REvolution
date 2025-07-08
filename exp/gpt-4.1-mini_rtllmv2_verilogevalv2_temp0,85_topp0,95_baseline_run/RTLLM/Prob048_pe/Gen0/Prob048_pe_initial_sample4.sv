module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // 64-bit product of a and b
    wire [63:0] product;
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 32'b0;
        else
            c <= c + product[31:0];  // accumulate lower 32 bits of product
    end

endmodule