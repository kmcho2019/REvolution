module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product_32bit;
    wire signed [31:0] next_c;

    // Calculate 32-bit product (explicit truncation)
    assign product_32bit = (a * b);

    // Next accumulation value
    assign next_c = c + product_32bit;

    // Register update
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= next_c;
        end
    end

endmodule