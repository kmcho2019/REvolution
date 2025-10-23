module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    reg signed [31:0] product;

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
            product <= 32'd0;
        end else begin
            product <= a * b;      // 32x32 multiplication
            c <= c + product;     // Accumulation
        end
    end

endmodule