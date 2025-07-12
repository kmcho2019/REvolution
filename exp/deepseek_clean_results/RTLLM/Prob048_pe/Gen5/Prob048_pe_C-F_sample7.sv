module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product;
    wire signed [31:0] next_c;

    // Combinational logic
    assign product = (a * b);  // Implicit 32-bit truncation
    assign next_c = rst ? 32'd0 : (c + product);

    // Sequential logic
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule