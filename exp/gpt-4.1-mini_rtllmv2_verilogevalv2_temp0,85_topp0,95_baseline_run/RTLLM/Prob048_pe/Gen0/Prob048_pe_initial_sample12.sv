module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Intermediate product as 64-bit to hold full multiplication result
    wire [63:0] product;
    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            // Accumulate lower 32 bits of product to c
            c <= c + product[31:0];
        end
    end

endmodule