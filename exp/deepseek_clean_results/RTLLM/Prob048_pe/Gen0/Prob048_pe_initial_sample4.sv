module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    wire signed [63:0] product;  // Temporary product (64-bit to prevent overflow)
    
    // Parallel multiplication
    assign product = a * b;
    
    // Accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;  // Reset accumulator
        end else begin
            c <= c + product[31:0];  // Accumulate lower 32 bits of product
        end
    end

endmodule