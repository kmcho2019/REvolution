module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product_low;  // Lower 32 bits of product
    wire signed [31:0] next_c;

    // Calculate the 32-bit truncated product
    assign product_low = a * b;

    // Calculate next accumulator value
    assign next_c = rst ? 32'd0 : (c + product_low);

    // Update accumulator register
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule