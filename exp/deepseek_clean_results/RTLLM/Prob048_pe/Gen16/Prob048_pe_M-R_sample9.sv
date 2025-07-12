module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product_low;  // Lower 32 bits of product
    wire signed [31:0] next_c;      // Next accumulator value

    // Calculate 32-bit product (lower bits only)
    assign product_low = a * b;

    // Combinational accumulation logic
    assign next_c = c + product_low;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= next_c;
        end
    end

endmodule