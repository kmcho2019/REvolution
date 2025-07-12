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

    // Calculate 32-bit product (lower bits of full multiplication)
    assign product = a * b;

    // Combinational accumulation path
    assign next_c = c + product;

    // Sequential register update
    always @(posedge clk) begin
        c <= rst ? 32'd0 : next_c;
    end

endmodule