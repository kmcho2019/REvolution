module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [63:0] product;
    wire signed [31:0] next_c;

    // Calculate product
    assign product = a * b;

    // Calculate next accumulator value
    assign next_c = rst ? 32'd0 : (c + product[31:0]);

    // Register update
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule