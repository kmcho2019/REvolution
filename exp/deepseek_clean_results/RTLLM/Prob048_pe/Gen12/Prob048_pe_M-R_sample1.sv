module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Combinational logic
    wire signed [63:0] full_product;
    wire signed [31:0] product_lower;
    
    assign full_product = a * b;
    assign product_lower = full_product[31:0];

    // Sequential logic
    always @(posedge clk) begin
        c <= rst ? 32'b0 : (c + product_lower);
    end

endmodule