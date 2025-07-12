module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signed product wire (32-bit truncated)
    wire signed [31:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;  // Synchronous reset with signed zero
        end else begin
            c <= c + product;  // Direct accumulation
        end
    end

endmodule