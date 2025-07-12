module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals
    wire signed [31:0] product = a * b;  // Automatic 32-bit truncation
    wire signed [31:0] accum_next = c + product;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= accum_next;
        end
    end

endmodule