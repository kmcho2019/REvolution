module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Direct 32-bit multiplication and accumulation
            // Explicit truncation by using 32-bit operands and result
            c <= c + (a * b);
        end
    end

endmodule