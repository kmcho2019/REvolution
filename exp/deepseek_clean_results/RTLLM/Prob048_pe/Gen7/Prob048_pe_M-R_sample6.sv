module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product_low;
    wire signed [31:0] next_c;

    // Combinational logic
    assign product_low = (a * b)[31:0];  // Explicit truncation
    assign next_c = rst ? 32'd0 : (c + product_low);

    // Sequential logic
    always @(posedge clk) begin
        c <= next_c;
    end

endmodule